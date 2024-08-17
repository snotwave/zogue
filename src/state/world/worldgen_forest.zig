const std = @import("std");
const rand = std.crypto.random;
const znoise = @import("znoise");

const Tile = @import("../../objects/tile.zig").Tile;
const World = @import("worldstate.zig").World;

const cartesian_distance = @import("../functions.zig").cartesian_distance;

const c = @import("../constants.zig");

const seed = 293468;

var generator = znoise.FnlGenerator{
    .seed = seed,
    .noise_type = .perlin,
    .octaves = 10,
    .fractal_type = .pingpong,
};

pub fn gen_noise(map: *[c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile) void {
    var noisemap = std.mem.zeroes([c.WORLD_WIDTH][c.WORLD_HEIGHT]usize);

    for (0..c.WORLD_WIDTH) |x| {
        for (0..c.WORLD_HEIGHT) |y| {
            const xf: f32 = @floatFromInt(x);
            const yf: f32 = @floatFromInt(y);

            const noisevalue: f32 = (1 + generator.noise2(xf, yf)) / 2;

            noisemap[x][y] = std.math.lossyCast(usize, std.math.round(noisevalue));
        }
    }

    for (0..c.WORLD_WIDTH) |x| {
        for (0..c.WORLD_HEIGHT) |y| {
            const offset = @rem(rand.int(usize), 10);

            const xx = @mod(x *% offset, c.WORLD_WIDTH);
            const yy = @mod(y *% offset, c.WORLD_HEIGHT);

            if (noisemap[xx][yy] == 0) {
                const choice: usize = @rem(rand.int(usize), 10);

                switch (choice) {
                    0, 1 => map[x][y].update(.floor_dirt),
                    else => map[x][y].update(.floor_grass),
                }
            } else map[x][y].update(.wall_tree);
        }
    }
}

pub fn gen_river(map: *[c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile, startx: usize, starty: usize, steps: usize) void {
    var x: usize = startx;
    var y: usize = starty;

    var iter: usize = 0;

    while (iter < steps) : (iter +%= 1) {
        const choice: usize = @mod(rand.int(usize), 350);

        switch (choice) {
            0...200 => y -= 1,
            201...275 => x += 1,
            276...350 => x -= 1,
            else => {},
        }

        const path_width = 1 + @rem(rand.int(usize), 4);

        if (x <= path_width or y <= path_width) break;

        // create path
        for (x -% path_width..x +% path_width) |i| {
            for (y -% path_width..y +% path_width) |j| {
                if (i >= c.WORLD_WIDTH or j >= c.WORLD_HEIGHT or i < 0 or j < 0) break;
                map[i][j].update(.water);
            }
        }
    }
}

pub fn build_bridge(map: *[c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile, x: usize, y: usize) void {
    var width: usize = 1;

    // if current tile is a path and the tile to the right is water
    if (map[x][y].id == 101 and map[x + 1][y].id == 1000) {
        while (width < 15) : (width +%= 1) {
            if (map[x + width][y].id == 1000) {
                map[x + width][y].update(.floor_bridge);
            }
        }
    }
}

pub fn gen_path(map: *[c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile, startx: usize, starty: usize, steps: usize) void {
    var x: usize = startx;
    var y: usize = starty;

    var iter: usize = 0;

    while (iter < steps) : (iter +%= 1) {
        const choice: usize = @mod(rand.int(usize), 350);

        switch (choice) {
            0...200 => x += 2,
            201...250 => y += 1,
            251...300 => {
                y += 1;
                x += 1;
            },
            301...350 => y -= 1,
            //201...250 => {
            //    y += 1;
            //    x -%= 1;
            //},
            //251...300 => {
            //    y -%= 1;
            //    x += 1;
            //},
            else => {},
        }

        if (x < startx or y < starty) {
            x = startx;
            y = starty;
            iter -%= 1;
        } else {
            const path_width = 2 + @rem(rand.int(usize), 2);

            // create path
            for (x -% path_width..x + path_width) |i| {
                for (y -% path_width..y + path_width) |j| {
                    if (i >= c.WORLD_WIDTH or j >= c.WORLD_HEIGHT) break;
                    map[i][j].update(.floor_dirtpath);
                    if (i > x + path_width - 3 or j > y + path_width - 3) map[i][j].update(.floor_grass);
                }
            }
        }
    }
}

pub fn worldgen(map: *[c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile) void {
    const offset = 60;
    const riverhead = offset + @mod(rand.int(usize), c.WORLD_WIDTH - offset);

    gen_noise(map);
    gen_path(map, 8, 8, 2000);
    gen_river(map, riverhead, c.WORLD_HEIGHT - 20, 2000);

    for (0..c.WORLD_WIDTH - 15) |x| {
        for (0..c.WORLD_HEIGHT) |y| {
            build_bridge(map, x, y);
        }
    }
}
