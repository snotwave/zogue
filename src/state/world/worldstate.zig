const c = @import("../constants.zig");

const Entity = @import("../../objects/entity.zig").Entity;
const Tile = @import("../../objects/tile.zig").Tile;
const Tile_Name = @import("../../objects/tile.zig").Tile_Name;
const Hero = @import("../../objects/hero.zig").Hero;

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
    layer: usize,

    pub fn init(layer: usize) !World {
        var map: [c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile = undefined;
        @memset(&map, .{.{}} ** c.WORLD_HEIGHT);

        worldgen_forest(&map);

        return .{
            .map = map,
            .layer = layer,
        };
    }

    pub fn draw(self: *World, window: vaxis.Window, port_x1: usize, port_x2: usize, port_y1: usize, port_y2: usize) void {
        for (port_x1..port_x2) |x| {
            for (port_y1..port_y2) |y| {

                // adjust the coordinates to the viewscreen
                const rel_x = @rem(x, c.VIEW_WIDTH);
                const rel_y = @rem(y, c.VIEW_HEIGHT);

                self.map[x][y].draw(window, rel_x, rel_y);
            }
        }
    }
};
