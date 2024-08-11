const vaxis = @import("vaxis");

pub const Tile = struct {
    glyph: []const u8 = " ",
    block_movement: bool = false,
    block_vision: bool = false,
    visible: bool = false,
    revealed: bool = false,
};

const Entity_Type = enum {
    player,
    npc,
};

pub const Entity = struct {
    xpos: usize,
    ypos: usize,
    dir: usize,
    glyph: []const u8,
    e_type: Entity_Type,

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

        window.writeCell(rel_x, rel_y, .{ .char = char });
        if (self.e_type == .player) {
            const pointer: vaxis.Cell.Character = .{ .grapheme = "○" };
            switch (self.dir) {
                0 => window.writeCell(rel_x +% 1, rel_y +% 0, .{ .char = pointer }),
                1 => window.writeCell(rel_x +% 1, rel_y +% 1, .{ .char = pointer }),
                2 => window.writeCell(rel_x +% 0, rel_y +% 1, .{ .char = pointer }),
                3 => window.writeCell(rel_x -% 1, rel_y +% 1, .{ .char = pointer }),
                4 => window.writeCell(rel_x -% 1, rel_y +% 0, .{ .char = pointer }),
                5 => window.writeCell(rel_x -% 1, rel_y -% 1, .{ .char = pointer }),
                6 => window.writeCell(rel_x +% 0, rel_y -% 1, .{ .char = pointer }),
                7 => window.writeCell(rel_x +% 1, rel_y -% 1, .{ .char = pointer }),
                else => {},
            }
        }
    }
};
