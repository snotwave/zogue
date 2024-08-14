const std = @import("std");

const init = std.mem.zeroes;
const lossyCast = std.math.lossyCast;
const round = std.math.round;

// as fun as it has been to diy most of this i am NOT implementing this by hand
const znoise = @import("znoise");
const world = @import("../world.zig");
const tile = @import("../tiles.zig");

const rects = @import("worldgen_rects.zig");
const rand = @import("std").crypto.random;

const width = world.world_width;
const height = world.world_height;

var generator = znoise.FnlGenerator{
    .seed = 920346,
    .noise_type = .perlin,
    .octaves = 8,
    .fractal_type = .pingpong,
};

pub fn gen_noise(map: *[width][height]tile.Tile) void {
    var noisemap = init([width][height]usize);

    for (0..width) |x| {
        for (0..height) |y| {
            const xf: f32 = @floatFromInt(x);
            const yf: f32 = @floatFromInt(y);

            const noisevalue: f32 = (1 + generator.noise2(xf, yf)) / 2;

            noisemap[x][y] = lossyCast(usize, round(noisevalue));
        }
    }

    for (0..width) |x| {
        for (0..height) |y| {
            if (noisemap[x][y] == 0)
                map[x][y].update(.floor_standard)
            else
                map[x][y].update(.wall_standard);
        }
    }
}

pub fn worldgen(map: *[width][height]tile.Tile) void {
    gen_noise(map);
}
