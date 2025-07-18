use penrose::builtin::actions::{exit, modify_with, spawn};
use penrose::core::bindings::{KeyCode, KeyEventHandler};
use penrose::x11rb::RustConn;

use std::collections::HashMap;

pub fn key_bindings() -> HashMap<KeyCode, Box<dyn KeyEventHandler<RustConn>>> {
    let mut map = HashMap::new();
    map.insert(
        KeyCode {
            mask: 1 << 6 | 1, // Meta + Shift
            code: 24,         // q
        },
        exit(),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 9,      // Esc
        },
        spawn("alacritty"),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 56,     // Esc
        },
        spawn("brave"),
    );

    // Window Control
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 23,     // Tab
        },
        modify_with(|cs| cs.swap_focus_and_head()),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 44,     // J
        },
        modify_with(|cs| cs.focus_down()),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 45,     // K
        },
        modify_with(|cs| cs.focus_up()),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6 | 1, // Meta + Shift
            code: 44,         // J
        },
        modify_with(|cs| cs.swap_down()),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6 | 1, // Meta + Shift
            code: 45,         // K
        },
        modify_with(|cs| cs.swap_up()),
    );

    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 10,     // 1
        },
        modify_with(|cs| cs.move_focused_to_tag("1")),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 11,     // 2
        },
        modify_with(|cs| cs.move_focused_to_tag("2")),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 12,     // 3
        },
        modify_with(|cs| cs.move_focused_to_tag("3")),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 13,     // 4
        },
        modify_with(|cs| cs.move_focused_to_tag("4")),
    );
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 14,     // 5
        },
        modify_with(|cs| cs.move_focused_to_tag("5")),
    );

    // Layout Controls
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 65,     // Space
        },
        modify_with(|cs| cs.next_layout()),
    );

    map.insert(
        KeyCode {
            mask: 1 << 2, // Ctrl
            code: 10,     // 1
        },
        modify_with(|cs| cs.focus_tag("1")),
    );
    map.insert(
        KeyCode {
            mask: 1 << 2, // Ctrl
            code: 11,     // 2
        },
        modify_with(|cs| cs.focus_tag("2")),
    );
    map.insert(
        KeyCode {
            mask: 1 << 2, // Ctrl
            code: 12,     // 3
        },
        modify_with(|cs| cs.focus_tag("3")),
    );
    map.insert(
        KeyCode {
            mask: 1 << 2, // Ctrl
            code: 13,     // 4
        },
        modify_with(|cs| cs.focus_tag("4")),
    );
    map.insert(
        KeyCode {
            mask: 1 << 2, // Ctrl
            code: 14,     // 5
        },
        modify_with(|cs| cs.focus_tag("5")),
    );
    map
}
