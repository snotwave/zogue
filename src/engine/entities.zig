const vaxis = @import("vaxis");
const std = @import("std");

const colors = @import("colors.zig");

const Entity_Type = enum {
    player,
    npc,
    nothing,
};

pub const Entity = struct {
    xpos: usize = 0,
    ypos: usize = 0,
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
            else => {},
        }

        return .{
            .xpos = x,
            .ypos = y,
            .glyph = glyph,
            .e_type = e_type,
            .fg_color = fg_color,
        };
    }

    pub fn draw(self: *Entity, window: vaxis.Window, rel_x: usize, rel_y: usize) void {
        const char: vaxis.Cell.Character = .{ .grapheme = self.glyph };
        const style: vaxis.Cell.Style = .{ .fg = self.fg_color };

        window.writeCell(rel_x, rel_y, .{ .char = char, .style = style });
    }
};
