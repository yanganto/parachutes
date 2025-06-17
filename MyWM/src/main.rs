//! My Windows Manager with Penrose
use penrose::extensions::hooks::named_scratchpads::NamedScratchPad;
use penrose::extensions::hooks::manage::FloatingCentered;
use penrose::extensions::layout::Tatami;
use penrose::stack;

use penrose::core::WindowManager;
use penrose::core::layout::LayoutStack;
use penrose::core::bindings::KeyCode;
use penrose::builtin::hooks::SpacingHook;
use penrose::core::Config;
use penrose::core::bindings::parse_keybindings_with_xmodmap;
use penrose::core::bindings::KeyEventHandler;
use penrose::extensions::hooks::add_named_scratchpads;
use penrose::extensions::hooks::manage::SetWorkspace;
use penrose::extensions::hooks::add_ewmh_hooks;
use penrose::x::query::ClassName;
use penrose::x11rb::RustConn;

use std::collections::HashMap;
use tracing_subscriber::{self, prelude::*};

pub const BAR_HEIGHT_PX: u32 = 24;
pub const GAP_PX: u32 = 5;

pub fn layouts() -> LayoutStack {
    stack!(
        // flex_main()
        // odd_even(),
        // Fibonacci::boxed_default(),
        // ReflectHorizontal::wrap(Fibonacci::boxed_default()),
        Tatami::boxed(0.6, 0.1)
    )
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
        HashMap::<KeyCode, Box<dyn KeyEventHandler<RustConn>>>::new(),
        // parse_keybindings_with_xmodmap(HashMap::<String, Box<dyn KeyEventHandler<RustConn>>>::new())?,
        HashMap::new(),
        RustConn::new()?,
    )?;

    // let wm = add_named_scratchpads(status_bar()?.add_to(wm), vec![nsp]);
    wm.run()?;

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
