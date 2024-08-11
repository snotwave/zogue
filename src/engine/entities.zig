const vaxis = @import("vaxis");

const Entity_Type = enum {
    player,
    npc,
};

pub const Entity = struct {
    xpos: usize,
    ypos: usize,
    dir: usize,
    e_type: Entity_Type,

    glyph: []const u8,
    fg_color: vaxis.Cell.Color = .{ .rgb = [_]u8{ 255, 255, 255 } },
    bg_color: vaxis.Cell.Color = .{ .rgb = [_]u8{ 255, 255, 255 } },

    pub fn init(x: usize, y: usize, glyph: []const u8, e_type: Entity_Type) Entity {
        return .{
            .xpos = x,
            .ypos = y,
            .glyph = glyph,
            .e_type = e_type,
            .dir = 0,
        };
    }

    pub fn draw(self: *Entity, window: vaxis.Window, rel_x: usize, rel_y: usize) void {
        const char: vaxis.Cell.Character = .{ .grapheme = self.glyph };
        const style: vaxis.Cell.Style = .{ .fg = self.fg_color };

        window.writeCell(rel_x, rel_y, .{ .char = char, .style = style });
    }
};
