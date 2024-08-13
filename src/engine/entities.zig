const vaxis = @import("vaxis");
const std = @import("std");

const world = @import("world.zig");

const colors = @import("colors.zig");

const Entity_Type = enum {
    player,
    debug,
    npc,
    nothing,
};

pub const Entity = struct {
    xpos: usize = 0,
    ypos: usize = 0,
    prev_x: usize = 0,
    prev_y: usize = 0,
    dir: usize = 0,

    glyph: []const u8 = "",
    fg_color: vaxis.Cell.Color = colors.default,
    bg_color: vaxis.Cell.Color = colors.default,

    e_type: Entity_Type = .nothing,

    pub fn init(x: usize, y: usize, e_type: Entity_Type) Entity {
        var glyph: []const u8 = " ";
        var fg_color: vaxis.Cell.Color = colors.white1;

        switch (e_type) {
            // set entity starting state based on Entity_Type
            .player => {
                glyph = "Ћ";
                fg_color = colors.orange;
            },
            .debug => {
                glyph = "प";
            },
            else => {},
        }

        return .{
            .xpos = x,
            .ypos = y,
            .prev_x = x,
            .prev_y = y,
            .glyph = glyph,
            .e_type = e_type,
            .fg_color = fg_color,
        };
    }

    pub fn draw(self: *Entity, window: vaxis.Window, rel_x: usize, rel_y: usize, wor: *world.World) void {
        const visible = wor.map[self.xpos][self.ypos].visible;
        const revealed = wor.map[self.xpos][self.ypos].revealed;

        const char: vaxis.Cell.Character = switch (revealed) {
            false => .{ .grapheme = " " },
            true => .{ .grapheme = self.glyph },
        };

        const style: vaxis.Cell.Style = switch (visible) {
            false => .{ .fg = colors.grey2 },
            true => .{ .fg = self.fg_color },
        };

        window.writeCell(rel_x, rel_y, .{ .char = char, .style = style });
    }
};
