const world = @import("world.zig");
const entity = @import("entities.zig");
const tile = @import("tiles.zig");

const euc_dist = @import("functions.zig").euc_dist;

const rand = @import("std").crypto.random;

const world_width = world.world_width;
const world_height = world.world_height;

const Rectangle = struct {
    height: usize = 0,
    width: usize = 0,
    ul_xpos: usize = 0,
    ul_ypos: usize = 0,
    ce_xpos: usize = 0,
    ce_ypos: usize = 0,
    id: tile.TileName = .floor_standard,

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
                map[x][y].update(self.id);
            }
        }
    }
};

pub fn worldgen_fill(map: *[world_width][world_height]tile.Tile) void {
    for (0..world_height) |y| {
        for (0..world_width) |x| {
            map[x][y].update(.wall_standard);
        }
    }
}

pub fn worldgen_make_rects(map: *[world_width][world_height]tile.Tile) void {
    const rect_count = 50;
    const max_width = 30;
    const max_height = 30;

    var rects: [rect_count]Rectangle = undefined;
    @memset(&rects, .{});

    for (0..rect_count) |i| {
        const x = @rem(rand.int(usize), world_width - max_width);
        const y = @rem(rand.int(usize), world_height - max_height);
        const width = 2 + @rem(rand.int(usize), max_width - 2);
        const height = 4 + @rem(rand.int(usize), max_height - 4);

        rects[i] = Rectangle.create(x, y, width, height, .floor_standard);
        rects[i].map_add(map);

        if (i < rect_count - 1) {
            worldgen_tunnel(rects[i], rects[i + 1], map);
        }
        if (i > 0) {
            worldgen_tunnel(rects[i - 1], rects[i], map);
        }
    }
}

pub fn worldgen_tunnel(rect_1: Rectangle, rect_2: Rectangle, map: *[world_width][world_height]tile.Tile) void {
    const cx1 = rect_1.ce_xpos;
    const cy1 = rect_1.ce_ypos;
    const cx2 = rect_2.ce_xpos;
    const cy2 = rect_2.ce_ypos;

    var tunnelx = cx1;
    var tunnely = cy1;

    const radius = @rem(rand.int(usize), 3) + 2;

    while (true) {
        if (euc_dist((tunnelx - 1), cx2) < (euc_dist((tunnelx), cx2))) {
            tunnelx -= 1;
        } else if (euc_dist((tunnelx + 1), cx2) < (euc_dist((tunnelx), cx2))) {
            tunnelx += 1;
        } else if (euc_dist((tunnely - 1), cy2) < (euc_dist((tunnely), cy2))) {
            tunnely -= 1;
        } else if (euc_dist((tunnely + 1), cy2) < (euc_dist((tunnely), cy2))) {
            tunnely += 1;
        } else break;

        for (1..radius) |i| {
            map[tunnelx + i][tunnely + i].update(.floor_standard);
            map[tunnelx - i][tunnely + i].update(.floor_standard);
            map[tunnelx + i][tunnely - i].update(.floor_standard);
            map[tunnelx - i][tunnely - i].update(.floor_standard);
        }
    }
}

pub fn worldgen_make_border(map: *[world_width][world_height]tile.Tile) void {
    for (0..world_height) |y| {
        for (0..world_width) |x| {
            if (x == 0 or x == world_width - 1 or y == 0 or y == world_height - 1) {
                map[x][y].update(.wall_standard);
            }
        }
    }
}

pub fn worldgen(map: *[world_width][world_height]tile.Tile) void {
    worldgen_fill(map);
    worldgen_make_rects(map);

    worldgen_make_border(map);
}
