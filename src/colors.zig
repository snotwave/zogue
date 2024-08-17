const vaxis = @import("vaxis");

const c_rgb = vaxis.Cell.Color;

fn color_rgb(r: u8, g: u8, b: u8) vaxis.Cell.Color {
    return .{ .rgb = [_]u8{ r, g, b } };
}

pub const dark_blue: c_rgb = color_rgb(29, 43, 83);
pub const light_blue: c_rgb = color_rgb(41, 173, 255);

pub const dark_pink: c_rgb = color_rgb(93, 39, 93);
pub const light_pink: c_rgb = color_rgb(255, 119, 168);

pub const dark_green: c_rgb = color_rgb(0, 135, 81);
pub const light_green: c_rgb = color_rgb(0, 228, 54);

pub const dark_brown: c_rgb = color_rgb(95, 87, 79);
pub const light_brown: c_rgb = color_rgb(171, 82, 54);

pub const dark_yellow: c_rgb = color_rgb(255, 163, 0);
pub const light_yellow: c_rgb = color_rgb(255, 236, 39);

pub const black: c_rgb = color_rgb(0, 0, 0);
pub const white: c_rgb = color_rgb(255, 241, 232);

pub const grey: c_rgb = color_rgb(194, 195, 199);
pub const tan: c_rgb = color_rgb(255, 204, 170);

pub const violet: c_rgb = color_rgb(131, 118, 156);
pub const red: c_rgb = color_rgb(255, 0, 77);

pub const grey2: c_rgb = color_rgb(51, 60, 87);
