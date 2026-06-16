#!/usr/bin/env bash
# simple scripts to enable ap mode
# Requires: iw, ip, iptables, hostapd, dnsmasq (run as root).
 
set -euo pipefail
 
usage() {
  cat << 'EOF'
Usage:
  enable_ap <WIFI_IFACE> <INTERNET_IFACE> <SSID> <PASSPHRASE>
 
Arguments:
  WIFI_IFACE      Wireless interface to use as the AP (e.g. wlan0)
  INTERNET_IFACE  Interface with internet access to share (e.g. eth0, wlan1)
  SSID            Network name to broadcast
  PASSPHRASE      WPA2 passphrase for the AP (min 8 characters)
 
Example:
  enable_ap wlan0 eth0 "MyHotspot" "s3cr3tpass"
 
Requires: iw, ip, iptables, hostapd, dnsmasq -- must be run as root.
EOF
}
 
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || "$#" -eq 0 ]]; then
  usage
  exit 0
fi
 
if [[ "$#" -lt 4 ]]; then
  echo "Error: expected 4 arguments, got $#." >&2
  echo >&2
  usage >&2
  exit 1
fi
 
echo "Enabling AP on $1 with internet on $2, SSID: $3"
 
WIFI_IFACE=$1
INTERNET_IFACE=$2
SSID="$3"
PASSPHRASE="$4"
GATEWAY=192.168.12.1
SUBNET=192.168.12.0/24
CHANNEL=1
DNS_PORT=5353
 
if [[ $(id -u) -ne 0 ]]; then
    echo "Must be run as root." >&2
    exit 1
fi

CONFDIR=$(mktemp -d /tmp/create_ap.${WIFI_IFACE}.conf.XXXXXXXX)
echo "Config dir: $CONFDIR"
 
cleanup() {
    echo
    echo -n "Cleaning up... "
 
    # stop hostapd / dnsmasq
    [[ -f $CONFDIR/hostapd.pid ]] && kill "$(cat "$CONFDIR/hostapd.pid")" 2>/dev/null || true
    [[ -f $CONFDIR/dnsmasq.pid ]] && kill "$(cat "$CONFDIR/dnsmasq.pid")" 2>/dev/null || true
 
    # remove iptables rules
    iptables -w -t nat -D POSTROUTING -s $SUBNET ! -o "$WIFI_IFACE" -j MASQUERADE 2>/dev/null || true
    iptables -w -D FORWARD -i "$WIFI_IFACE" -s $SUBNET -j ACCEPT 2>/dev/null || true
    iptables -w -D FORWARD -i "$INTERNET_IFACE" -d $SUBNET -j ACCEPT 2>/dev/null || true
 
    iptables -w -D INPUT -p tcp -m tcp --dport $DNS_PORT -j ACCEPT 2>/dev/null || true
    iptables -w -D INPUT -p udp -m udp --dport $DNS_PORT -j ACCEPT 2>/dev/null || true
    iptables -w -t nat -D PREROUTING -s $SUBNET -d $GATEWAY -p tcp -m tcp --dport 53 \
        -j REDIRECT --to-ports $DNS_PORT 2>/dev/null || true
    iptables -w -t nat -D PREROUTING -s $SUBNET -d $GATEWAY -p udp -m udp --dport 53 \
        -j REDIRECT --to-ports $DNS_PORT 2>/dev/null || true
    iptables -w -D INPUT -p udp -m udp --dport 67 -j ACCEPT 2>/dev/null || true
 
    # bring the wifi interface back down
    ip link set down dev "$WIFI_IFACE" 2>/dev/null || true
    ip addr flush "$WIFI_IFACE" 2>/dev/null || true
 
    rm -rf "$CONFDIR"

    nmcli device set $WIFI_IFACE managed yes

    echo "done"
}
trap cleanup EXIT INT TERM
 
# --- write hostapd config ---
cat << EOF > "$CONFDIR/hostapd.conf"
beacon_int=100
ssid=${SSID}
interface=${WIFI_IFACE}
driver=nl80211
channel=${CHANNEL}
ctrl_interface=$CONFDIR/hostapd_ctrl
ctrl_interface_group=0
ignore_broadcast_ssid=0
ap_isolate=0
hw_mode=g
wpa=2
wpa_passphrase=${PASSPHRASE}
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
EOF
 
# --- write dnsmasq config ---
MTU=$(cat "/sys/class/net/${INTERNET_IFACE}/mtu" 2>/dev/null || true)
cat << EOF > "$CONFDIR/dnsmasq.conf"
listen-address=${GATEWAY}
bind-dynamic
dhcp-range=${GATEWAY%.*}.1,${GATEWAY%.*}.254,255.255.255.0,24h
dhcp-option-force=option:router,${GATEWAY}
dhcp-option-force=option:dns-server,${GATEWAY}
EOF
[[ -n "$MTU" ]] && echo "dhcp-option-force=option:mtu,${MTU}" >> "$CONFDIR/dnsmasq.conf"

nmcli device set $WIFI_IFACE managed no
 
# --- bring up the wifi interface (no virtual interface, --no-virt) ---
iw dev "$WIFI_IFACE" set power_save off
ip link set down dev "$WIFI_IFACE"
ip addr flush "$WIFI_IFACE"
ip link set up dev "$WIFI_IFACE"
ip addr add ${GATEWAY}/24 broadcast ${GATEWAY%.*}.255 dev "$WIFI_IFACE"
 
# --- NAT internet sharing ---
echo "Sharing Internet using NAT"
iptables -w -t nat -I POSTROUTING -s $SUBNET ! -o "$WIFI_IFACE" -j MASQUERADE
iptables -w -I FORWARD -i "$WIFI_IFACE" -s $SUBNET -j ACCEPT
iptables -w -I FORWARD -i "$INTERNET_IFACE" -d $SUBNET -j ACCEPT
echo 1 > "/proc/sys/net/ipv4/conf/${INTERNET_IFACE}/forwarding"
echo 1 > /proc/sys/net/ipv4/ip_forward
modprobe nf_nat_pptp > /dev/null 2>&1 || true
 
# --- DNS redirect + DHCP ---
iptables -w -I INPUT -p tcp -m tcp --dport $DNS_PORT -j ACCEPT
iptables -w -I INPUT -p udp -m udp --dport $DNS_PORT -j ACCEPT
iptables -w -t nat -I PREROUTING -s $SUBNET -d $GATEWAY -p tcp -m tcp --dport 53 \
    -j REDIRECT --to-ports $DNS_PORT
iptables -w -t nat -I PREROUTING -s $SUBNET -d $GATEWAY -p udp -m udp --dport 53 \
    -j REDIRECT --to-ports $DNS_PORT
iptables -w -I INPUT -p udp -m udp --dport 67 -j ACCEPT
 
dnsmasq -C "$CONFDIR/dnsmasq.conf" -x "$CONFDIR/dnsmasq.pid" -l "$CONFDIR/dnsmasq.leases" -p $DNS_PORT
 
# --- start hostapd (foreground; Ctrl+C triggers cleanup) ---
echo "hostapd command-line interface: hostapd_cli -p $CONFDIR/hostapd_ctrl"
hostapd "$CONFDIR/hostapd.conf" &
HOSTAPD_PID=$!
echo $HOSTAPD_PID > "$CONFDIR/hostapd.pid"
wait $HOSTAPD_PID
