const vaxis = @import("vaxis");
const std = @import("std");
const rand = std.crypto.random;

const World = @import("../state/world/worldstate.zig").World;

const c = @import("../colors.zig");

const Entity_Name = enum {

    // debug
    debug,
    player,

    // npcs
    mouse,
};

const Entity_Category = enum { debug, npc, nothing };

pub const Entity = struct {
    id: usize = 0,
    category: Entity_Category = .nothing,

    glyph: []const u8 = "",
    color: vaxis.Cell.Color = c.white,

    xpos: usize = 0,
    ypos: usize = 0,
    prev_x: usize = 0,
    prev_y: usize = 0,
    dir: usize = 0,

    alive: bool = true,

    pub fn init(self: *Entity, name: Entity_Name, xpos: usize, ypos: usize) void {
        switch (name) {
            .mouse => {
                self.category = .npc;
                self.xpos = xpos;
                self.ypos = ypos;
                self.prev_x = xpos;
                self.prev_y = ypos;
                self.glyph = "ੴ";
                self.color = c.light_yellow;
            },

            else => {},
        }
    }

    pub fn update_previous(self: *Entity, wor: *World) void {
        if (!self.is_visible(wor)) return;
        self.prev_x = self.xpos;
        self.prev_y = self.ypos;
    }

    pub fn draw(self: *Entity, window: vaxis.Window, xpos: usize, ypos: usize, wor: *World) void {
        const char: vaxis.Cell.Character = switch (self.is_revealed(wor)) {
            true => .{ .grapheme = self.glyph },
            false => .{ .grapheme = " " },
        };

        const style: vaxis.Cell.Style = switch (self.is_visible(wor)) {
            true => .{ .fg = self.color },
            false => .{ .fg = c.grey2 },
        };

        window.writeCell(xpos + 1, ypos + 1, .{ .char = char, .style = style });
    }

    // this is for debug purposes
    pub fn random_walk(self: *Entity) void {
        const random = @mod(rand.int(usize), 100);

        switch (random) {
            0...25 => self.xpos +%= 1,
            51...75 => self.ypos +%= 1,
            else => {},
        }
    }

    pub fn is_visible(self: *Entity, wor: *World) bool {
        return wor.get_tile(self.xpos, self.ypos).visible;
    }

    pub fn is_revealed(self: *Entity, wor: *World) bool {
        return wor.get_tile(self.xpos, self.ypos).revealed;
    }

    pub fn has_los(self: *Entity, x: usize, y: usize, world: World) bool {
        const x_0: isize = @as(isize, x);
        const y_0: isize = @as(isize, y);

        var x_1: isize = @as(isize, self.xpos);
        var y_1: isize = @as(isize, self.ypos);

        const dx = @abs(x_1 - x_0);
        const dy = @abs(y_1 - y_0);

        const sx = switch (x_0 < x_1) {
            true => 1,
            false => -1,
        };

        const sy = switch (y_0 < y_1) {
            true => 1,
            false => -1,
        };

        var err = dx - dy;

        while (true) {
            const e2 = 2 * err;

            if (e2 > -dy) {
                err -= dy;
                x_1 += sx;
            }

            if (e2 < dx) {
                err += dx;
                y_1 += sy;
            }

            if (x_0 == x_1 and y_0 == y_1) {
                return true;
            }

            const ux = @as(usize, x_1);
            const uy = @as(usize, y_1);

            if (world.map[ux][uy].block_vision == true) {
                return 0;
            }
        }
    }
};
