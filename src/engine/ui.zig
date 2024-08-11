const vaxis = @import("vaxis");

const engine_world = @import("world.zig");

pub fn draw_border(window: vaxis.Window) void {
    const line: vaxis.Cell.Character = .{ .grapheme = "░" };
    const corner: vaxis.Cell.Character = .{ .grapheme = "▓" };

    const max_width = engine_world.view_width + 1;
    const max_height = engine_world.view_height + 1;

    for (1..max_width) |x| {
        window.writeCell(x, 0, .{ .char = line });
        window.writeCell(x, max_height, .{ .char = line });
    }
    for (1..max_height) |y| {
        window.writeCell(0, y, .{ .char = line });
        window.writeCell(max_width, y, .{ .char = line });
    }

    window.writeCell(0, 0, .{ .char = corner });
    window.writeCell(0, max_height, .{ .char = corner });
    window.writeCell(max_width, 0, .{ .char = corner });
    window.writeCell(max_width, max_height, .{ .char = corner });
}
