const world = @import("world.zig");
const entity = @import("entities.zig");
const tile = @import("tiles.zig");

const std = @import("std");

const rand = std.crypto.random;

const world_width = world.world_width;
const world_height = world.world_height;

const Rectangle = struct {
    height: usize,
    width: usize,
    ul_xpos: usize,
    ul_ypos: usize,
    ce_xpos: usize,
    ce_ypos: usize,
    id: tile.TileName,

    pub fn create(x: usize, y: usize, width: usize, height: usize, id: tile.TileName) Rectangle {
        const ce_xpos = x + @divFloor(width, 2);
        const ce_ypos = y + @divFloor(height, 2);

        return .{
            .ul_xpos = x,
            .ul_ypos = y,
            .width = width,
            .height = height,
            .ce_xpos = ce_xpos,
            .ce_ypos = ce_ypos,
            .id = id,
        };
    }

    pub fn map_add(self: Rectangle, map: *[world_width][world_height]tile.Tile) void {
        for (self.ul_xpos..self.ul_xpos + self.width) |x| {
            for (self.ul_ypos..self.ul_ypos + self.height) |y| {
                map[x][y] = tile.Tile.init(self.id);
            }
        }
    }
};

pub fn worldgen_fill(map: *[world_width][world_height]tile.Tile) void {
    for (0..world_height) |y| {
        for (0..world_width) |x| {
            map[x][y] = tile.Tile.init(.wall_standard);
        }
    }
}

pub fn worldgen_make_rects(map: *[world_width][world_height]tile.Tile) void {
    const rect_count = 35 + @rem(rand.int(usize), 10);
    const max_width = 30;
    const max_height = 30;

    for (0..rect_count) |_| {
        const x = @rem(rand.int(usize), world_width - max_width);
        const y = @rem(rand.int(usize), world_height - max_height);
        const width = 4 + @rem(rand.int(usize), max_width - 4);
        const height = 6 + @rem(rand.int(usize), max_height - 6);

        const rect = Rectangle.create(x, y, width, height, .floor_standard);
        rect.map_add(map);
    }
}

pub fn worldgen_make_border(map: *[world_width][world_height]tile.Tile) void {
    for (0..world_height) |y| {
        for (0..world_width) |x| {
            if (x == 0 or x == world_width - 1 or y == 0 or y == world_height - 1) {
                map[x][y] = tile.Tile.init(.wall_standard);
            }
        }
    }
}

pub fn worldgen(map: *[world_width][world_height]tile.Tile) void {
    worldgen_fill(map);
    worldgen_make_rects(map);

    worldgen_make_border(map);
}
