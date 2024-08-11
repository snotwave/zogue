const vaxis = @import("vaxis");

const entity = @import("entities.zig");
const tile = @import("tiles.zig");
const worldgen = @import("worldgen.zig");

pub const world_width: usize = 320;
pub const world_height: usize = 72;

// MUST ALWAYS BE DIVISORS OF world_width AND world_height RESPECTIVELY
// (if not can cause over/underflows)
pub const view_width: usize = 80;
pub const view_height: usize = 24;

pub const world_type = enum {
    Swamp,
    Forest,
    Dungeon,
};

pub const World = struct {
    player: entity.Entity,
    map: [world_width][world_height]tile.Tile,
    terrain: world_type = .Swamp,

    pub fn init() World {
        var map: [world_width][world_height]tile.Tile = undefined;

        worldgen.worldgen(&map);

        return .{
            .player = entity.Entity.init(9, 9, "Ћ", .player),
            .map = map,
        };
    }

    pub fn draw(self: *World, window: vaxis.Window) void {
        const player_relx = @rem(self.player.xpos, view_width);
        const player_rely = @rem(self.player.ypos, view_height);

        // splits the world into rooms based on player position
        const quad_x = @divFloor(self.player.xpos, view_width);
        const quad_y = @divFloor(self.player.ypos, view_height);

        // defines the boundaries for those rooms
        const port_xmin = quad_x * view_width;
        const port_ymin = quad_y * view_height;
        const port_xmax = (quad_x + 1) * view_width;
        const port_ymax = (quad_y + 1) * view_height;

        // draw tiles
        for (port_ymin..port_ymax) |y| {
            for (port_xmin..port_xmax) |x| {
                const relx = @rem(x, view_width);
                const rely = @rem(y, view_height);
                const char: vaxis.Cell.Character = .{ .grapheme = self.map[x][y].glyph };
                const style: vaxis.Cell.Style = .{ .fg = self.map[x][y].fg_color };
                window.writeCell(relx + 1, rely + 1, .{ .char = char, .style = style });
            }
        }

        //draw player
        self.player.draw(window, player_relx + 1, player_rely + 1);
    }
};
