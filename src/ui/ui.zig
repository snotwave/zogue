const vaxis = @import("vaxis");

const engine_world = @import("../engine/world.zig");
const colors = @import("../engine/colors.zig");

const hline: vaxis.Cell.Character = .{ .grapheme = "┄" };
const vline: vaxis.Cell.Character = .{ .grapheme = "┊" };
const corner: vaxis.Cell.Character = .{ .grapheme = "▓" };

const color: vaxis.Cell.Style = .{ .fg = colors.orange };

pub fn draw_rectangle(x1: usize, y1: usize, x2: usize, y2: usize, window: vaxis.Window) void {
    for (x1..x2) |x| {
        window.writeCell(x, y1, .{ .char = hline, .style = color });
        window.writeCell(x, y2, .{ .char = hline, .style = color });
    }
    for (y1..y2) |y| {
        window.writeCell(x1, y, .{ .char = vline, .style = color });
        window.writeCell(x2, y, .{ .char = vline, .style = color });
    }

    window.writeCell(x1, y1, .{ .char = corner, .style = color });
    window.writeCell(x1, y2, .{ .char = corner, .style = color });
    window.writeCell(x2, y1, .{ .char = corner, .style = color });
    window.writeCell(x2, y2, .{ .char = corner, .style = color });
}

pub fn draw_border(window: vaxis.Window) void {

    // draw viewbox
    draw_rectangle(0, 0, engine_world.view_width + 1, engine_world.view_height + 1, window);

    // draw messagebox
    draw_rectangle(0, engine_world.view_height + 3, engine_world.view_width + 1, engine_world.view_height + 7, window);

    // draw sidepanel
    draw_rectangle(engine_world.view_width + 3, 0, engine_world.view_width + 19, engine_world.view_height + 7, window);
}
