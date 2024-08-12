const vaxis = @import("vaxis");

pub const TileName = enum {
    // floor names
    floor_standard,

    // wall names
    wall_standard,
};

pub const Tile = struct {
    glyph: []const u8 = " ",
    block_movement: bool = false,
    block_vision: bool = false,
    visible: bool = true,
    revealed: bool = true,

    fg_color: vaxis.Cell.Color = .{ .rgb = [_]u8{ 255, 255, 255 } },
    bg_color: vaxis.Cell.Color = .{ .rgb = [_]u8{ 255, 255, 255 } },

    pub fn update(self: *Tile, name: TileName) void {
        switch (name) {

            //floors
            .floor_standard => {
                self.glyph = ".";
                self.block_movement = false;
                self.fg_color = .{ .rgb = [_]u8{ 117, 113, 97 } };
            },

            // walls
            .wall_standard => return {
                self.glyph = "█";
                self.block_movement = true;
                self.fg_color = .{ .rgb = [_]u8{ 78, 74, 78 } };
            },
        }
    }

    pub fn draw(self: *Tile, window: vaxis.Window, rel_x: usize, rel_y: usize) void {
        const char: vaxis.Cell.Character = .{ .grapheme = self.glyph };
        const style: vaxis.Cell.Style = .{ .fg = self.fg_color };

        window.writeCell(rel_x + 1, rel_y + 1, .{ .char = char, .style = style });
    }
};
