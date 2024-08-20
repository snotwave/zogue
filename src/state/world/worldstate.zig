const c = @import("../constants.zig");

const Entity = @import("../../objects/entity.zig").Entity;
const Tile = @import("../../objects/tile.zig").Tile;
const Tile_Name = @import("../../objects/tile.zig").Tile_Name;
const Hero = @import("../../objects/hero.zig").Hero;
const State_World_Flags = @import("worldstate_flags.zig").State_World_Flags;

const update_fov = @import("fov.zig").update_fov;

// various worldgen algorithms
const worldgen_default = @import("worldgen_default.zig").worldgen;
const worldgen_forest = @import("worldgen_forest.zig").worldgen;

const std = @import("std");
const vaxis = @import("vaxis");

pub const State_World = struct {
    layers: []World,
    current_layer: usize = 0,
    hero: Hero = .{},
    flags: State_World_Flags = .{},
    allocator: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator) !State_World {
        var layers: []World = try alloc.alloc(World, c.LAYERS);

        for (0..c.LAYERS) |i| {
            layers[i] = try World.init(i);
        }

        return .{
            .layers = layers,
            .allocator = alloc,
        };
    }

    pub fn deinit(self: *State_World) void {
        self.allocator.free(self.layers);
    }

    fn draw_hero(self: *State_World, win: vaxis.Window) void {
        const rel_x = @rem(self.hero.xpos, c.VIEW_WIDTH);
        const rel_y = @rem(self.hero.ypos, c.VIEW_HEIGHT);

        self.hero.draw(rel_x, rel_y, win);
    }

    pub fn draw(self: *State_World, win: vaxis.Window) void {

        // divides world into quadrants, each the size of a full viewscreen
        const quad_x = @divFloor(self.hero.xpos, c.VIEW_WIDTH);
        const quad_y = @divFloor(self.hero.ypos, c.VIEW_HEIGHT);

        // defines the boundaries of each of those quadrants
        const port_x1 = quad_x * c.VIEW_WIDTH;
        const port_y1 = quad_y * c.VIEW_HEIGHT;

        const port_x2 = (quad_x + 1) * c.VIEW_WIDTH;
        const port_y2 = (quad_y + 1) * c.VIEW_HEIGHT;

        const current_layer = self.current_layer;

        update_fov(self);
        self.layers[current_layer].draw(win, port_x1, port_x2, port_y1, port_y2);

        self.draw_hero(win);
    }
};

pub const World = struct {
    map: [c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile,
    entity: [c.ENTITY_LIMIT]Entity,
    layer: usize,

    pub fn init(layer: usize) !World {
        var map: [c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile = undefined;
        @memset(&map, .{.{}} ** c.WORLD_HEIGHT);

        worldgen_forest(&map);

        var entity: [c.ENTITY_LIMIT]Entity = undefined;
        @memset(&entity, .{});

        entity[0].init(.mouse, 1, 1);

        return .{
            .map = map,
            .entity = entity,
            .layer = layer,
        };
    }

    pub fn get_tile(self: *World, x: usize, y: usize) Tile {
        return self.map[x][y];
    }

    pub fn draw(self: *World, window: vaxis.Window, port_x1: usize, port_x2: usize, port_y1: usize, port_y2: usize) void {

        // draw tiles
        for (port_x1..port_x2) |x| {
            for (port_y1..port_y2) |y| {
                self.map[x][y].contains_entity = false;

                // adjust the coordinates to the viewscreen
                const rel_x = @rem(x, c.VIEW_WIDTH);
                const rel_y = @rem(y, c.VIEW_HEIGHT);

                self.map[x][y].draw(window, rel_x, rel_y);
            }
        }
        // draw entities

        for (0..c.ENTITY_LIMIT) |i| {
            var this_entity = self.entity[i];

            self.map[this_entity.xpos][this_entity.ypos].contains_entity = true;

            if (this_entity.xpos >= port_x1 and this_entity.xpos < port_x2 and this_entity.ypos >= port_y1 and this_entity.ypos < port_y2) {
                var rel_x: usize = 0;
                var rel_y: usize = 0;

                if (!this_entity.is_visible(self)) {
                    rel_x = @rem(this_entity.prev_x, c.VIEWBOX_WIDTH);
                    rel_y = @rem(this_entity.prev_y, c.VIEWBOX_HEIGHT);

                    if (self.map[rel_x][rel_y].visible == true) break;
                } else {
                    rel_x = @rem(this_entity.xpos, c.VIEWBOX_WIDTH);
                    rel_y = @rem(this_entity.ypos, c.VIEWBOX_HEIGHT);
                }

                this_entity.draw(window, rel_x, rel_y, self);
            }
        }
    }

    pub fn logic(self: *World) void {
        for (0..c.ENTITY_LIMIT) |i| {
            if (self.entity[i].category != .nothing)
                self.entity[i].random_walk();
            self.entity[i].update_previous(self);
        }
    }
};
