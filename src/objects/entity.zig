const vaxis = @import("vaxis");
const std = @import("std");

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

    pub fn init(self: *Entity, name: Entity_Name, xpos: usize, ypos: usize) void {
        switch (name) {
            .mouse => {
                self.xpos = xpos;
                self.ypos = ypos;
                self.glyph = "ੴ";
                self.color = c.grey2;
            },

            else => {},
        }
    }

    pub fn draw(self: *Entity, window: vaxis.Window, xpos: usize, ypos: usize, wor: *World) void {
        const visible = wor.get_tile(xpos, ypos).visible;
        const revealed = wor.get_tile(xpos, ypos).revealed;

        const char: vaxis.Cell.Character = switch (revealed) {
            true => .{ .grapheme = self.glyph },
            false => .{ .grapheme = " " },
        };

        const style: vaxis.Cell.Style = switch (visible) {
            true => .{ .fg = self.color },
            false => .{ .fg = c.grey2 },
        };

        window.writeCell(xpos, ypos, .{ .char = char, .style = style });
    }
};
