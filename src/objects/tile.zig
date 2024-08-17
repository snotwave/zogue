const vaxis = @import("vaxis");
const std = @import("std");

const rand = @import("std").crypto.random;

const c = @import("../colors.zig");

pub const Tile_Name = enum {

    // floors
    floor_standard,
    floor_dirtpath,
    floor_grass,
    floor_dirt,
    floor_bridge,

    // walls
    wall_standard,
    wall_tree,

    // utilities
    //stairs_down_standard,
    //stairs_up_standard,

    // other
    water,
};

pub const Tile_Category = enum {
    default,

    // level change
    stairs_down,
    stairs_up,
};

pub const Tile = struct {
    id: usize = 0,
    category: Tile_Category = .default,

    glyph: []const u8 = " ",
    block_movement: bool = false,
    block_vision: bool = false,
    visible: bool = false,
    revealed: bool = false,

    color: vaxis.Cell.Color = c.white,

    pub fn update(self: *Tile, name: Tile_Name) void {
        switch (name) {
            .floor_standard => return {
                self.id = 100;
                self.glyph = ".";
                self.color = c.grey;
                self.block_movement = false;
                self.block_vision = false;
            },
            .floor_grass => return {
                self.id = 102;
                self.glyph = "⁙";
                self.color = c.dark_green;
                self.block_movement = false;
                self.block_vision = false;
            },
            .floor_dirtpath => return {
                self.id = 101;
                self.glyph = ":";
                self.color = c.dark_brown;
                self.block_movement = false;
                self.block_vision = false;
            },
            .floor_dirt => return {
                self.id = 103;
                self.glyph = "⁘";
                self.color = c.dark_brown;
                self.block_movement = false;
                self.block_vision = false;
            },
            .floor_bridge => return {
                self.id = 104;
                self.glyph = "=";
                self.color = c.grey;
                self.block_movement = false;
                self.block_vision = false;
            },

            .wall_standard => return {
                self.id = 200;
                self.glyph = "X";
                self.color = c.white;
                self.block_vision = true;
                self.block_movement = true;
            },

            .wall_tree => return {
                const choice: usize = @mod(rand.int(usize), 10);

                self.id = 201;
                self.glyph = "ⵖ";
                self.color = switch (choice) {
                    0, 1 => c.light_green,
                    2 => c.tan,
                    else => c.dark_green,
                };
                self.block_vision = true;
                self.block_movement = true;
            },

            .water => return {
                const choice: usize = @mod(rand.int(usize), 10);

                self.id = 1000;
                self.glyph = "~";
                self.color = switch (choice) {
                    0, 1 => c.dark_blue,
                    2 => c.white,
                    else => c.light_blue,
                };
                self.block_vision = false;
                self.block_movement = true;
            },
        }
    }

    pub fn draw(self: *Tile, window: vaxis.Window, x: usize, y: usize) void {
        // if tile has been seen once, remain visible even when not currently seeing it
        self.revealed = switch (self.visible) {
            true => true,
            false => self.revealed,
        };

        // don't draw if tile has not been revealed
        const char: vaxis.Cell.Character = switch (self.revealed) {
            true => .{ .grapheme = self.glyph },
            false => .{ .grapheme = " " },
        };

        // if tile has been revealed but isn't currently visible draw it grey
        const style: vaxis.Cell.Style = switch (self.visible) {
            true => .{ .fg = self.color },
            false => .{ .fg = c.grey2 },
        };

        // add an extra 1 to account for the ui
        window.writeCell(x + 1, y + 1, .{ .char = char, .style = style });
    }
};
