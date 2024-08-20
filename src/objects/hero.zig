const vaxis = @import("vaxis");

const c = @import("../colors.zig");

const State_World = @import("../state/world/worldstate.zig").State_World;

pub const Hero = struct {

    // position related
    xpos: usize = 8,
    ypos: usize = 8,
    dir: usize = 0,
    layer: usize = 0,

    // draw related
    glyph: []const u8 = "Ѧ",
    color: vaxis.Cell.Color = c.violet,

    // gamestate related
    name: []const u8 = "isabel",

    health_current: usize = 100,
    health_maximum: usize = 100,

    xp_current: usize = 0,
    xp_maximum: usize = 100,

    level_current: usize = 1,

    pub fn draw(self: *Hero, x: usize, y: usize, window: vaxis.Window) void {
        // add an extra 1 to account for the ui
        window.writeCell(x + 1, y + 1, .{ .char = .{ .grapheme = self.glyph }, .style = .{ .fg = self.color } });
    }

    pub fn move(self: *Hero, world: State_World, dx: isize, dy: isize) void {
        const map = world.layers[world.current_layer].map;

        const temp_x: isize = @intCast(self.xpos);
        const temp_y: isize = @intCast(self.ypos);

        const new_dx: usize = @intCast(dx +% temp_x);
        const new_dy: usize = @intCast(dy +% temp_y);

        if (map[new_dx][new_dy].block_movement == false and map[new_dx][new_dy].contains_entity == false) {
            self.xpos = new_dx;
            self.ypos = new_dy;
        }
    }

    pub fn rotate(self: *Hero, dir: isize) void {
        switch (dir) {
            1 => {
                if (self.dir == 7) {
                    self.dir = 0;
                } else self.dir += 1;
            },
            -1 => {
                if (self.dir == 0) {
                    self.dir = 7;
                } else self.dir -%= 1;
            },
            else => {},
        }
    }
};
