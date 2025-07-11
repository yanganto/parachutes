//! My Windows Manager with Penrose
use penrose::builtin::actions::{exit, modify_with, spawn};
use penrose::builtin::layout::{CenteredMain, MainAndStack, Monocle};
use penrose::core::layout::Layout;
use penrose::extensions::hooks::manage::FloatingCentered;
use penrose::extensions::hooks::named_scratchpads::NamedScratchPad;
use penrose::extensions::layout::{Conditional, Tatami};
use penrose::map;
use penrose::stack;

use penrose::builtin::hooks::SpacingHook;
use penrose::core::bindings::parse_keybindings_with_xmodmap;
use penrose::core::bindings::KeyCode;
use penrose::core::bindings::KeyEventHandler;
use penrose::core::layout::LayoutStack;
use penrose::core::Config;
use penrose::core::WindowManager;
use penrose::extensions::hooks::add_ewmh_hooks;
use penrose::extensions::hooks::add_named_scratchpads;
use penrose::extensions::hooks::manage::SetWorkspace;
use penrose::x::query::ClassName;
use penrose::x11rb::RustConn;

use mwm::bar::status_bar;
use std::collections::HashMap;
use std::time::Duration;
use tracing_subscriber::{self, prelude::*};

pub const BAR_HEIGHT_PX: u32 = 24;
pub const GAP_PX: u32 = 5;

pub fn layouts() -> LayoutStack {
    stack!(
        flex_main(),
        // odd_even(),
        // Fibonacci::boxed_default(),
        // ReflectHorizontal::wrap(Fibonacci::boxed_default()),
        Monocle::boxed(),
        Tatami::boxed(0.6, 0.1)
    )
}

fn flex_main() -> Box<dyn Layout> {
    Conditional::boxed(
        "FlexMain",
        MainAndStack::default(),
        CenteredMain::default(),
        |_, r| r.w <= 1400,
    )
}

fn key_bindings() -> HashMap<KeyCode, Box<dyn KeyEventHandler<RustConn>>> {
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

    // Worksapce Controls
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 23,     // Tab
        },
        modify_with(|cs| cs.toggle_tag()),
    );

    // Layout Controls
    map.insert(
        KeyCode {
            mask: 1 << 6, // Meta
            code: 65,     // Space
        },
        modify_with(|cs| cs.toggle_tag()),
    );
    map
}

fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter("info")
        .finish()
        .init();

    // let (nsp, toggle_scratch) = NamedScratchPad::new(
    //     "alacritty",
    //     "alacritty",
    //     ClassName("StScratchpad"),
    //     FloatingCentered::new(0.8, 0.8),
    //     true,
    // );

    let wm = WindowManager::new(
        add_ewmh_hooks(config()),
        key_bindings(),
        HashMap::new(),
        RustConn::new()?,
    )?;

    // let wm = add_named_scratchpads(status_bar()?.add_to(wm), vec![]);
    let wm_with_bar = status_bar()?.add_to(wm);
    wm_with_bar.run()?;

    Ok(())
}

fn config() -> Config<RustConn> {
    let manage_hook = Box::new((ClassName("obs"), SetWorkspace("1")));
    let layout_hook = Box::new(SpacingHook {
        inner_px: GAP_PX,
        outer_px: GAP_PX,
        top_px: BAR_HEIGHT_PX,
        bottom_px: 0,
    });

    Config {
        default_layouts: layouts(),
        startup_hook: None,
        layout_hook: Some(layout_hook),
        manage_hook: Some(manage_hook),
        ..Config::default()
    }
}
