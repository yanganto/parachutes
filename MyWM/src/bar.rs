use penrose::{x::XConn, Color};

pub const FONT: &str = "Iosevka";
pub const POINT_SIZE: u8 = 12;

pub const BAR_HEIGHT_PX: u32 = 24;
pub const GAP_PX: u32 = 5;

pub const DEEP_OCEAN: u32 = 0x030F1CFF;
pub const WHITE: u32 = 0xFFFFFFFF;
pub const AQUA: u32 = 0x86A1B2FF;
pub const SEA: u32 = 0x4DA2FFFF;

use penrose_ui::{
    bar::{
        widgets::{
            sys::interval::{amixer_volume, battery_summary, current_date_and_time, wifi_network},
            ActiveWindowName, CurrentLayout, Workspaces,
        },
        Position, StatusBar,
    },
    core::TextStyle,
};
use std::time::Duration;

const MAX_ACTIVE_WINDOW_CHARS: usize = 250;

pub fn status_bar<X: XConn>() -> penrose_ui::Result<StatusBar<X>> {
    let highlight: Color = AQUA.into();
    let empty_ws: Color = SEA.into();

    let style = TextStyle {
        fg: WHITE.into(),
        bg: Some(DEEP_OCEAN.into()),
        padding: (2, 2),
    };

    let padded_style = TextStyle {
        padding: (4, 2),
        ..style
    };

    StatusBar::try_new(
        Position::Top,
        BAR_HEIGHT_PX,
        style.bg.unwrap_or_else(|| 0x000000.into()),
        FONT,
        POINT_SIZE,
        vec![
            Box::new(Workspaces::new(style, SEA, empty_ws)),
            Box::new(CurrentLayout::new(style)),
            Box::new(ActiveWindowName::new(
                MAX_ACTIVE_WINDOW_CHARS,
                TextStyle {
                    bg: Some(highlight),
                    padding: (6, 4),
                    ..style
                },
                true,
                false,
            )),
            Box::new(wifi_network(padded_style, Duration::new(5, 0))),
            Box::new(battery_summary("BAT1", padded_style, Duration::new(5, 0))),
            Box::new(battery_summary("BAT0", padded_style, Duration::new(5, 0))),
            Box::new(amixer_volume("Master", padded_style, Duration::new(5, 0))),
            Box::new(current_date_and_time(padded_style, Duration::new(5, 0))),
        ],
    )
}
