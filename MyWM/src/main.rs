//! My Windows Manager with Penrose
use penrose::builtin::layout::{CenteredMain, MainAndStack, Monocle};
use penrose::core::layout::Layout;
use penrose::extensions::layout::{Conditional, Tatami};
use penrose::stack;

use penrose::builtin::hooks::SpacingHook;
use penrose::core::layout::LayoutStack;
use penrose::core::Config;
use penrose::core::WindowManager;
use penrose::extensions::hooks::add_ewmh_hooks;
use penrose::extensions::hooks::manage::SetWorkspace;
use penrose::x::query::ClassName;
use penrose::x11rb::RustConn;

use mwm::bar::status_bar;
use mwm::keybinds::key_bindings;
use std::collections::HashMap;
use tracing_subscriber::{self, prelude::*};

pub const BAR_HEIGHT_PX: u32 = 24;
pub const GAP_PX: u32 = 0;

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

fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter("info")
        .finish()
        .init();

    let wm = WindowManager::new(
        add_ewmh_hooks(config()),
        key_bindings(),
        HashMap::new(),
        RustConn::new()?,
    )?;

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
        tags: vec![
            "1".to_string(),
            "2".to_string(),
            "3".to_string(),
            "4".to_string(),
            "5".to_string(),
        ],
        ..Config::default()
    }
}
