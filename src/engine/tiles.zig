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
            },

            // walls
            .wall_standard => return {
                self.glyph = "█";
                self.block_movement = true;
            },
        }
    }
};
