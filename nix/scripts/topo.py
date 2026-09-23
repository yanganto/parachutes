#!/usr/bin/env python3
"""
Server that periodically runs:
    plotnetcfg | dot -Grankdir=LR -Tsvg > topology.svg
and serves a web page that live-renders the SVG, keeps a history of
snapshots, detects when the graph changed, and lets you browse past
diffs side-by-side with scroll-locked panes.

Usage:
    topo [--interval 5] [--port 8000] [--history 30]

Requires: root, plotnetcfg and graphviz (dot) installed.
"""

import argparse
import json
import subprocess
import threading
import time
import datetime
import os
import sys
import itertools
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

# The script is stored read-only in the nix store, so write the SVG to the
# working directory instead of next to the script file.
SVG_PATH = os.path.join(os.getcwd(), "topology.svg")

# --- shared state -----------------------------------------------------
# `current` always holds the most recent snapshot (svg + timestamp), even
# when it hasn't changed since the previous poll. `timeline` only ever
# gets a new entry when either (a) the svg actually differs from `current`
# at the time of the check (kind="diff"), or (b) the user manually adds a
# text note (kind="note"). Unchanged polls never get appended anywhere, so
# `--history N` really means "keep the last N *changes/notes*", not "last
# N fetches". Each diff entry is self-contained (carries both the before
# and after svg/timestamp) so it keeps working even after older entries
# have been trimmed out. The user can also wipe the whole timeline.
state_lock = threading.Lock()
current = {"svg": None, "timestamp": None}
timeline = []  # list of {id, kind: "diff"|"note", timestamp, ...}
history_max = 30
id_counter = itertools.count(1)
last_error = None


def _trim_timeline():
    if len(timeline) > history_max:
        del timeline[0 : len(timeline) - history_max]


def add_note(text):
    ts = datetime.datetime.now().isoformat(timespec="seconds")
    with state_lock:
        entry = {"id": next(id_counter), "kind": "note", "timestamp": ts, "text": text}
        timeline.append(entry)
        _trim_timeline()
        return entry


def clear_history():
    with state_lock:
        timeline.clear()


def regenerate_svg():
    global last_error
    try:
        plotnetcfg = subprocess.run(
            ["plotnetcfg"],
            capture_output=True,
            check=True,
            timeout=30,
        )
        dot = subprocess.run(
            ["dot", "-Grankdir=LR", "-Tsvg"],
            input=plotnetcfg.stdout,
            capture_output=True,
            check=True,
            timeout=30,
        )
        svg_text = dot.stdout.decode("utf-8", errors="replace")

        with open(SVG_PATH, "w") as f:
            f.write(svg_text)

        ts = datetime.datetime.now().isoformat(timespec="seconds")

        with state_lock:
            prev_svg, prev_ts = current["svg"], current["timestamp"]

            if prev_svg is not None and prev_svg != svg_text:
                # Real change detected -> record a diff entry.
                timeline.append(
                    {
                        "id": next(id_counter),
                        "kind": "diff",
                        "timestamp": ts,
                        "before_svg": prev_svg,
                        "before_ts": prev_ts,
                        "after_svg": svg_text,
                        "after_ts": ts,
                    }
                )
                _trim_timeline()

            # Always advance "current" to the latest poll, whether or not
            # the content changed, so the live view and the next diff's
            # "before" both reflect the freshest known state.
            current["svg"] = svg_text
            current["timestamp"] = ts
            last_error = None

    except subprocess.CalledProcessError as e:
        err = e.stderr.decode("utf-8", errors="replace") if e.stderr else str(e)
        with state_lock:
            last_error = f"Command failed: {err}"
    except Exception as e:
        with state_lock:
            last_error = f"Error: {e}"


def background_updater(interval):
    while True:
        regenerate_svg()
        time.sleep(interval)


PAGE_TEMPLATE = """<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Network Topology</title>
    <style>
        * {{ box-sizing: border-box; }}
        html, body {{ margin: 0; padding: 0; height: 100%; font-family: sans-serif; background: #fafafa; }}

        #header {{
            position: fixed; top: 0; left: 0; right: 0; height: 56px;
            background: #222; color: #fff; z-index: 100;
            display: flex; align-items: center; gap: 1rem; padding: 0 1rem;
            box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        }}
        #header button {{ padding: 0.4rem 0.8rem; cursor: pointer; }}
        #status {{ font-size: 0.95rem; }}
        #badge {{
            padding: 0.15rem 0.5rem; border-radius: 4px; font-size: 0.8rem;
        }}
        .badge-live {{ background: #2a6; }}
        .badge-diff {{ background: #d63; }}
        #error-banner {{
            color: #fff; background: #b00; font-size: 0.85rem;
            padding: 0 0.5rem; max-width: 40vw; overflow: hidden;
            text-overflow: ellipsis; white-space: nowrap;
        }}

        #body-wrap {{ display: flex; padding-top: 56px; height: 100vh; }}

        #sidebar {{
            position: fixed; top: 56px; bottom: 0; left: 0; width: 260px;
            overflow-y: auto; background: #f0f0f0; border-right: 1px solid #ddd;
            z-index: 90;
        }}
        #sidebar h3 {{ font-size: 0.85rem; text-transform: uppercase; color: #666; padding: 0.75rem 0.75rem 0.25rem; margin: 0; }}
        .sidebar-item {{
            padding: 0.5rem 0.75rem; cursor: pointer; border-bottom: 1px solid #e5e5e5;
            font-size: 0.85rem;
        }}
        .sidebar-item:hover {{ background: #e6e6e6; }}
        .sidebar-item.active {{ background: #d7e8ff; }}
        .sidebar-item .tag {{
            display: inline-block; font-size: 0.7rem; padding: 0.05rem 0.4rem;
            border-radius: 3px; margin-right: 0.4rem; color: #fff;
        }}
        .tag-changed {{ background: #d63; }}
        .tag-note {{ background: #37a; }}

        #main {{ margin-left: 260px; flex: 1; padding: 1rem; overflow: auto; transition: margin-left 0.15s ease; }}
        body.sidebar-hidden #sidebar {{ display: none; }}
        body.sidebar-hidden #main {{ margin-left: 0; }}

        #single-view svg, .diff-pane svg {{ max-width: 100%; height: auto; }}
        #single-view {{ border: 1px solid #ddd; background: #fff; padding: 0.5rem; }}

        #diff-view {{ display: flex; gap: 0.5rem; }}
        .diff-col {{ flex: 1; min-width: 0; }}
        .diff-col h4 {{ margin: 0 0 0.4rem 0; font-size: 0.85rem; color: #444; }}
        .diff-pane {{
            border: 1px solid #ddd; background: #fff; padding: 0.5rem;
            height: 80vh; overflow: auto;
        }}
        .diff-pane.before {{ border-left: 4px solid #999; }}
        .diff-pane.after {{ border-left: 4px solid #d63; }}

        #note-view {{
            border: 1px solid #ddd; background: #fff; padding: 1rem;
            border-left: 4px solid #37a;
        }}
        #note-view .note-ts {{ color: #666; font-size: 0.85rem; margin-bottom: 0.5rem; }}
        #note-view .note-text {{ white-space: pre-wrap; font-size: 1rem; }}
    </style>
</head>
<body>
    <div id="header">
        <button onclick="refreshNow()">Refresh now</button>
        <button onclick="addEvent()">Add event</button>
        <button onclick="clearHistory()">Clear history</button>
        <button id="sidebar-toggle-btn" onclick="toggleSidebar()">Hide sidebar</button>
        <span id="badge" class="badge-live">LIVE</span>
        <span id="status">Last updated: never</span>
        <span id="error-banner"></span>
    </div>

    <div id="body-wrap">
        <div id="sidebar">
            <h3>View</h3>
            <div class="sidebar-item active" id="live-item" onclick="goLive()">&#9679; Live (latest)</div>
            <h3>Timeline</h3>
            <div id="diff-list"></div>
        </div>

        <div id="main">
            <div id="single-view">Loading...</div>
            <div id="diff-view" style="display:none;">
                <div class="diff-col">
                    <h4 id="before-label">Before</h4>
                    <div class="diff-pane before" id="pane-before"></div>
                </div>
                <div class="diff-col">
                    <h4 id="after-label">After</h4>
                    <div class="diff-pane after" id="pane-after"></div>
                </div>
            </div>
            <div id="note-view" style="display:none;">
                <div class="note-ts" id="note-ts"></div>
                <div class="note-text" id="note-text"></div>
            </div>
        </div>
    </div>

    <script>
        const POLL_MS = {poll_interval_ms};
        let mode = 'live';       // 'live' or 'pinned'
        let selectedId = null;   // when pinned via sidebar click (diff or note)
        let knownLatestDiffId = null; // last diff id we've already auto-shown once
        let syncingScroll = false;
        let lastHistoryItems = [];

        function fmtTs(ts) {{
            return ts || 'never';
        }}

        async function fetchJSON(url, opts) {{
            const res = await fetch(url, opts);
            return res.json();
        }}

        function truncate(text, n) {{
            if (!text) return '';
            return text.length > n ? text.slice(0, n) + '…' : text;
        }}

        function renderSidebar(items) {{
            const list = document.getElementById('diff-list');
            list.innerHTML = '';
            if (items.length === 0) {{
                list.innerHTML = '<div class="sidebar-item">Nothing yet</div>';
                return;
            }}
            const entries = items.slice().reverse(); // newest first
            for (const it of entries) {{
                const div = document.createElement('div');
                div.className = 'sidebar-item' + (selectedId === it.id ? ' active' : '');
                if (it.kind === 'note') {{
                    div.innerHTML = '<span class="tag tag-note">NOTE</span>' + it.timestamp +
                        '<br><span style="color:#555">' + truncate(it.text, 60) + '</span>';
                    div.onclick = () => showNote(it.id);
                }} else {{
                    div.innerHTML = '<span class="tag tag-changed">CHANGED</span>' + it.timestamp;
                    div.onclick = () => showDiff(it.id);
                }}
                list.appendChild(div);
            }}
        }}

        function renderSidebarActive() {{
            renderSidebar(lastHistoryItems);
        }}

        function setLiveBadgeActive(isLive) {{
            document.getElementById('live-item').classList.toggle('active', isLive);
        }}

        function setupScrollLock() {{
            const a = document.getElementById('pane-before');
            const b = document.getElementById('pane-after');
            function link(src, dst) {{
                src.onscroll = () => {{
                    if (syncingScroll) return;
                    syncingScroll = true;
                    dst.scrollTop = src.scrollTop;
                    dst.scrollLeft = src.scrollLeft;
                    syncingScroll = false;
                }};
            }}
            link(a, b);
            link(b, a);
        }}

        async function renderDiffPair(data) {{
            document.getElementById('single-view').style.display = 'none';
            document.getElementById('note-view').style.display = 'none';
            document.getElementById('diff-view').style.display = 'flex';
            document.getElementById('before-label').textContent = 'Before (' + fmtTs(data.before_ts) + ')';
            document.getElementById('after-label').textContent = 'After (' + fmtTs(data.after_ts) + ')';
            document.getElementById('pane-before').innerHTML = data.before_svg || '<em>(no earlier snapshot)</em>';
            document.getElementById('pane-after').innerHTML = data.after_svg;
            setupScrollLock();
        }}

        function showNoteView(item) {{
            document.getElementById('single-view').style.display = 'none';
            document.getElementById('diff-view').style.display = 'none';
            document.getElementById('note-view').style.display = 'block';
            document.getElementById('note-ts').textContent = fmtTs(item.timestamp);
            document.getElementById('note-text').textContent = item.text;
        }}

        async function goLive() {{
            mode = 'live';
            selectedId = null;
            setLiveBadgeActive(true);
            document.getElementById('diff-view').style.display = 'none';
            document.getElementById('note-view').style.display = 'none';
            document.getElementById('single-view').style.display = 'block';
            await refreshData();
        }}

        async function showDiff(id) {{
            mode = 'pinned';
            selectedId = id;
            setLiveBadgeActive(false);
            const data = await fetchJSON('/diff/' + id);
            if (data.error) {{
                alert(data.error);
                return;
            }}
            await renderDiffPair(data);
            document.getElementById('status').textContent = 'Viewing diff at ' + fmtTs(data.after_ts);
            document.getElementById('badge').textContent = 'DIFF (pinned)';
            document.getElementById('badge').className = 'badge-diff';
            renderSidebarActive();
        }}

        function showNote(id) {{
            mode = 'pinned';
            selectedId = id;
            setLiveBadgeActive(false);
            const item = lastHistoryItems.find(it => it.id === id);
            if (!item) return;
            showNoteView(item);
            document.getElementById('status').textContent = 'Viewing note at ' + fmtTs(item.timestamp);
            document.getElementById('badge').textContent = 'NOTE';
            document.getElementById('badge').className = 'badge-diff';
            renderSidebarActive();
        }}

        async function addEvent() {{
            const text = window.prompt('Event text:');
            if (!text) return;
            await fetch('/add-event', {{
                method: 'POST',
                headers: {{ 'Content-Type': 'application/json' }},
                body: JSON.stringify({{ text: text }}),
            }});
            const hist = await fetchJSON('/history');
            lastHistoryItems = hist.items;
            renderSidebarActive();
        }}

        async function clearHistory() {{
            if (!window.confirm('Clear all diff/note history? This cannot be undone.')) return;
            await fetch('/clear-history', {{ method: 'POST' }});
            knownLatestDiffId = null;
            await goLive();
        }}

        function toggleSidebar() {{
            const hidden = document.body.classList.toggle('sidebar-hidden');
            document.getElementById('sidebar-toggle-btn').textContent = hidden ? 'Show sidebar' : 'Hide sidebar';
        }}

        async function refreshData() {{
            const [latest, hist] = await Promise.all([
                fetchJSON('/svg-data'),
                fetchJSON('/history'),
            ]);
            lastHistoryItems = hist.items;
            document.getElementById('error-banner').textContent = latest.error || '';

            if (mode === 'pinned') {{
                // stay pinned on the user-selected diff; just refresh sidebar list
                renderSidebarActive();
                return;
            }}

            // LIVE mode: if a *new* diff has appeared since we last checked,
            // auto-show it side by side once. Otherwise just show the
            // current live graph. Unchanged polls never touch the diff
            // history at all, so this only fires on real changes.
            const isNewDiff = latest.latest_diff_id !== null &&
                               latest.latest_diff_id !== knownLatestDiffId;

            if (isNewDiff) {{
                knownLatestDiffId = latest.latest_diff_id;
                const data = await fetchJSON('/diff/' + latest.latest_diff_id);
                await renderDiffPair(data);
                document.getElementById('badge').textContent = 'DIFF (auto)';
                document.getElementById('badge').className = 'badge-diff';
            }} else {{
                document.getElementById('diff-view').style.display = 'none';
                document.getElementById('note-view').style.display = 'none';
                document.getElementById('single-view').style.display = 'block';
                document.getElementById('single-view').innerHTML = latest.svg;
                document.getElementById('badge').textContent = 'LIVE';
                document.getElementById('badge').className = 'badge-live';
                if (latest.latest_diff_id !== null) {{
                    knownLatestDiffId = latest.latest_diff_id;
                }}
            }}

            document.getElementById('status').textContent = 'Last updated: ' + fmtTs(latest.last_updated);
            renderSidebar(lastHistoryItems);
        }}

        async function refreshNow() {{
            document.getElementById('status').textContent = 'Refreshing...';
            await fetch('/refresh', {{ method: 'POST' }});
            await refreshData();
        }}

        refreshData();
        setInterval(() => {{
            if (mode !== 'pinned') {{
                refreshData();
            }} else {{
                // still poll sidebar list even when pinned to a past diff
                fetchJSON('/history').then(hist => {{
                    lastHistoryItems = hist.items;
                    renderSidebarActive();
                }});
            }}
        }}, POLL_MS);
    </script>
</body>
</html>
"""


class Handler(BaseHTTPRequestHandler):
    poll_interval_ms = 5000

    def log_message(self, format, *args):
        pass

    def do_GET(self):
        if self.path == "/":
            html = PAGE_TEMPLATE.format(poll_interval_ms=self.poll_interval_ms)
            self._send(200, "text/html", html.encode("utf-8"))

        elif self.path == "/svg-data":
            with state_lock:
                svg = current["svg"]
                latest_diff_id = None
                for item in reversed(timeline):
                    if item["kind"] == "diff":
                        latest_diff_id = item["id"]
                        break
                if svg is None:
                    payload = {
                        "svg": "<svg xmlns='http://www.w3.org/2000/svg'><text x='10' y='20'>No data yet</text></svg>",
                        "last_updated": None,
                        "latest_diff_id": None,
                        "error": last_error,
                    }
                else:
                    payload = {
                        "svg": svg,
                        "last_updated": current["timestamp"],
                        "latest_diff_id": latest_diff_id,
                        "error": last_error,
                    }
            self._send(200, "application/json", json.dumps(payload).encode("utf-8"))

        elif self.path == "/history":
            with state_lock:
                items = []
                for t in timeline:
                    if t["kind"] == "note":
                        items.append({"id": t["id"], "kind": "note", "timestamp": t["timestamp"], "text": t["text"]})
                    else:
                        items.append({"id": t["id"], "kind": "diff", "timestamp": t["after_ts"]})
            self._send(200, "application/json", json.dumps({"items": items}).encode("utf-8"))

        elif self.path.startswith("/diff/"):
            try:
                snap_id = int(self.path.rsplit("/", 1)[-1])
            except ValueError:
                self._send(400, "application/json", b'{"error": "invalid id"}')
                return
            with state_lock:
                entry = next(
                    (t for t in timeline if t["kind"] == "diff" and t["id"] == snap_id), None
                )
                if entry is None:
                    payload = {"error": "diff not found (may have rolled out of history)"}
                else:
                    payload = {
                        "before_svg": entry["before_svg"],
                        "before_ts": entry["before_ts"],
                        "after_svg": entry["after_svg"],
                        "after_ts": entry["after_ts"],
                    }
            self._send(200, "application/json", json.dumps(payload).encode("utf-8"))

        elif self.path == "/whoami":
            ip = self.client_address[0]
            now = datetime.datetime.now().isoformat(timespec="seconds")
            self._send(200, "text/plain", f"{ip} {now}".encode("utf-8"))

        else:
            self._send(404, "text/plain", b"Not found")
        if self.path == "/refresh":
            regenerate_svg()
            self._send(200, "text/plain", b"ok")

        elif self.path == "/clear-history":
            clear_history()
            self._send(200, "text/plain", b"ok")

        elif self.path == "/add-event":
            length = int(self.headers.get("Content-Length", 0))
            raw = self.rfile.read(length) if length else b""
            try:
                data = json.loads(raw.decode("utf-8")) if raw else {}
            except json.JSONDecodeError:
                self._send(400, "application/json", b'{"error": "invalid json"}')
                return
            text = (data.get("text") or "").strip()
            if not text:
                self._send(400, "application/json", b'{"error": "text is required"}')
                return
            entry = add_note(text)
            self._send(200, "application/json", json.dumps({"id": entry["id"], "timestamp": entry["timestamp"]}).encode("utf-8"))

        else:
            self._send(404, "text/plain", b"Not found")

    def _send(self, code, content_type, body):
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


def main():
    global history_max
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--interval", type=float, default=5.0,
                         help="Seconds between automatic regenerations (default: 5)")
    parser.add_argument("--port", type=int, default=8000,
                         help="Port to serve on (default: 8000)")
    parser.add_argument("--history", type=int, default=30,
                         help="Max number of snapshots to keep in memory (default: 30)")
    args = parser.parse_args()

    if os.geteuid() != 0:
        sys.exit("Error: topo must be run as root.")

    history_max = args.history
    Handler.poll_interval_ms = int(args.interval * 1000)

    updater = threading.Thread(target=background_updater, args=(args.interval,), daemon=True)
    updater.start()

    server = ThreadingHTTPServer(("0.0.0.0", args.port), Handler)
    print(f"Serving on http://0.0.0.0:{args.port}  (regenerating every {args.interval}s, keeping last {history_max} diffs)")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down.")


if __name__ == "__main__":
    main()