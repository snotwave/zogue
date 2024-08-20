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
        const choice: usize = @mod(rand.int(usize), 400);

        if (y > 0) {
            switch (choice) {
                0...200 => y -= 1,
                201...275 => {
                    y -= 1;
                    x += 1;
                },
                276...350 => {
                    y -= 1;
                    x -= 1;
                },
                351...375 => x += 2,
                376...400 => x -= 2,
                else => {},
            }
        }

        const path_width = 2 + @rem(rand.int(usize), 4);

        if (y >= path_width) {
            // create river
            for (x -% path_width..x +% path_width) |i| {
                for (y -% path_width..y +% path_width) |j| {
                    if (j >= 0 and cartesian_distance(x, y, i, j) < path_width) {
                        map[i][j].update(.water);
                    }
                }
            }
        }
    }
}

pub fn pad_river(map: *[c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile, x: usize, y: usize) void {
    const padding = 2 + @mod(rand.int(usize), 3);

    if (map[x][y].id == 1000 and map[x +% 1][y].id != 1000) {
        var i: usize = 1;
        while (i < padding + 1) : (i +%= 1) {
            if (map[x +% i][y].id != 1000) {
                map[x +% i][y].update(.floor_grass);
            }
        }
    }
    if (map[x][y].id == 1000 and map[x -% 1][y].id != 1000) {
        var i: usize = 1;
        while (i < padding + 1) : (i +%= 1) {
            if (map[x -% i][y].id != 1000) {
                map[x -% i][y].update(.floor_grass);
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
            else => {},
        }

        const path_width = 1 + @rem(rand.int(usize), 2);

        // create path
        for (x -% path_width..x + path_width) |i| {
            for (y -% path_width..y + path_width) |j| {
                if (i >= c.WORLD_WIDTH or j >= c.WORLD_HEIGHT) break;
                map[i][j].update(.floor_dirtpath);
            }
        }
    }
}

pub fn pad_path(map: *[c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile, x: usize, y: usize) void {
    const padding = 1 + @mod(rand.int(usize), 1);

    if (map[x][y].id == 101 and map[x][y +% 1].id != 101) {
        var i: usize = 1;
        while (i < padding + 1) : (i +%= 1) {
            if (map[x][y +% i].id != 101) {
                map[x][y +% i].update(.floor_grass);
            }
        }
    }
    if (map[x][y].id == 101 and map[x][y -% 1].id != 101) {
        var i: usize = 1;

        if (i - 1 < 0) return;

        while (i < padding + 1) : (i +%= 1) {
            if (map[x][y -% i].id != 101) {
                map[x][y -% i].update(.floor_grass);
            }
        }
    }
}

pub fn worldgen(map: *[c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile) void {
    const offset = 60;
    const riverhead = offset + @mod(rand.int(usize), c.WORLD_WIDTH - 2 * offset);

    gen_noise(map);
    gen_path(map, 8, 8, 2000);
    gen_river(map, riverhead, c.WORLD_HEIGHT - 20, 2000);

    for (0..c.WORLD_WIDTH - 15) |x| {
        for (0..c.WORLD_HEIGHT) |y| {
            build_bridge(map, x, y);
        }
    }

    for (0..c.WORLD_WIDTH) |x| {
        for (0..c.WORLD_HEIGHT) |y| {
            pad_river(map, x, y);
            pad_path(map, x, y);
        }
    }
}
