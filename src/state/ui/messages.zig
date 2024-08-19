const vaxis = @import("vaxis");

pub const message = struct {
    message: []const u8 = "",
    style: vaxis.Cell.Style = .{},
};
