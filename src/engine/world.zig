const std = @import("std");
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

pub const entity_limit: usize = 128;

pub const world_type = enum {
    Swamp,
    Forest,
    Dungeon,
};

pub const World = struct {
    entities: [entity_limit]entity.Entity,
    map: [world_width][world_height]tile.Tile,
    terrain: world_type = .Swamp,

    pub fn init() !World {

        // initialize an empty worldmap with default tile values
        var map: [world_width][world_height]tile.Tile = undefined;
        @memset(&map, .{.{}} ** world_height);

        worldgen.worldgen(&map);

        var entities: [entity_limit]entity.Entity = undefined;
        @memset(&entities, .{});

        yit: for (0..view_width) |x| {
            for (0..view_height) |y| {
                if (map[x][y].block_movement == false and map[x + 1][y + 1].block_movement == false) {
                    entities[0] = entity.Entity.init(x + 1, y + 1, .player);
                    break :yit;
                } else continue;
            }
        }
        // entities[0] = entity.Entity.init(9, 9, .player);

        return .{
            .entities = entities,
            .map = map,
        };
    }

    fn draw_tiles(self: *World, window: vaxis.Window, xmin: usize, xmax: usize, ymin: usize, ymax: usize) void {
        for (ymin..ymax) |y| {
            for (xmin..xmax) |x| {
                const relx = @rem(x, view_width);
                const rely = @rem(y, view_height);
                self.map[x][y].draw(window, relx, rely);
            }
        }
    }

    fn draw_entities(self: *World, window: vaxis.Window, xmin: usize, xmax: usize, ymin: usize, ymax: usize) void {
        for (0..entity_limit) |i| {
            const this_entity = &self.entities[i];
            const x = this_entity.xpos;
            const y = this_entity.ypos;

            if ((this_entity.e_type != .nothing) and (xmin <= x) and (x <= xmax) and (ymin <= y) and (y <= ymax)) {
                const relx = @rem(this_entity.xpos, view_width);
                const rely = @rem(this_entity.ypos, view_height);

                this_entity.draw(window, relx + 1, rely + 1);
            }
        }
    }

    pub fn draw(self: *World, window: vaxis.Window) void {
        const player = &self.entities[0];
        // splits the world into rooms based on player position
        const quad_x = @divFloor(player.xpos, view_width);
        const quad_y = @divFloor(player.ypos, view_height);

        // defines the boundaries for those rooms
        const port_xmin = quad_x * view_width;
        const port_ymin = quad_y * view_height;
        const port_xmax = (quad_x + 1) * view_width;
        const port_ymax = (quad_y + 1) * view_height;

        // draw tiles
        self.draw_tiles(window, port_xmin, port_xmax, port_ymin, port_ymax);

        // draw_entities
        self.draw_entities(window, port_xmin, port_xmax, port_ymin, port_ymax);
    }
};
