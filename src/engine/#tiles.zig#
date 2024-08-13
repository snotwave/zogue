const vaxis = @import("vaxis");
const colors = @import("colors.zig");

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
    visible: bool = false,
    revealed: bool = false,

    fg_color: vaxis.Cell.Color = colors.default,
    bg_color: vaxis.Cell.Color = colors.default,

    pub fn update(self: *Tile, name: TileName) void {
        switch (name) {

            //floors
            .floor_standard => {
                self.glyph = "~";
                self.block_vision = false;
                self.block_movement = false;
                self.fg_color = colors.red;
            },

            // walls
            .wall_standard => return {
                self.glyph = "█";
                self.block_movement = true;
                self.block_vision = true;
                self.fg_color = colors.orange;
            },
        }
    }

    pub fn draw(self: *Tile, window: vaxis.Window, rel_x: usize, rel_y: usize) void {
        self.revealed = switch (self.visible) {
            false => self.revealed,
            true => true,
        };

        const char: vaxis.Cell.Character = switch (self.revealed) {
            false => .{ .grapheme = " " },
            true => .{ .grapheme = self.glyph },
        };

        const style: vaxis.Cell.Style = switch (self.visible) {
            false => .{ .fg = colors.grey2 },
            true => .{ .fg = self.fg_color },
        };

        window.writeCell(rel_x + 1, rel_y + 1, .{ .char = char, .style = style });
    }
};
