const vaxis = @import("vaxis");

const con = @import("../constants.zig");
const col = @import("../../colors.zig");

const hline: vaxis.Cell.Character = .{ .grapheme = "┄" };
const vline: vaxis.Cell.Character = .{ .grapheme = "┊" };
const corner: vaxis.Cell.Character = .{ .grapheme = "▓" };

const color: vaxis.Cell.Style = .{ .fg = col.dark_blue };

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
    draw_rectangle(0, 0, con.VIEWBOX_WIDTH, con.VIEWBOX_HEIGHT, window);

    // draw messagebox
    draw_rectangle(0, con.VIEWBOX_HEIGHT + con.UI_GAP, con.VIEWBOX_WIDTH, con.UI_HEIGHT, window);

    // draw sidepanel
    draw_rectangle(con.VIEWBOX_WIDTH + con.UI_GAP, 0, con.UI_WIDTH, con.VIEWBOX_HEIGHT + con.UI_GAP + con.UI_MESSAGE_HEIGHT, window);
}
