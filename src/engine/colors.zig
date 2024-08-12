const vaxis = @import("vaxis");

const c_rgb = vaxis.Cell.Color;

pub const darkblue: c_rgb = .{ .rgb = [_]u8{ 26, 28, 44 } };
pub const magenta: c_rgb = .{ .rgb = [_]u8{ 93, 39, 93 } };
pub const red: c_rgb = .{ .rgb = [_]u8{ 177, 62, 83 } };
pub const orange: c_rgb = .{ .rgb = [_]u8{ 239, 125, 87 } };
pub const white1: c_rgb = .{ .rgb = [_]u8{ 244, 244, 244 } };
pub const white2: c_rgb = .{ .rgb = [_]u8{ 148, 176, 194 } };
pub const grey1: c_rgb = .{ .rgb = [_]u8{ 86, 108, 134 } };
pub const grey2: c_rgb = .{ .rgb = [_]u8{ 51, 60, 87 } };

pub const default: c_rgb = .{ .rgb = [_]u8{ 255, 255, 255 } };
