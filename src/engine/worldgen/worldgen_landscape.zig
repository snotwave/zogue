const rand = @import("std").crypto.random;

const world = @import("../world.zig");
const entity = @import("../entities.zig");
const tile = @import("../tiles.zig");

const world_width = world.world_width;
const world_height = world.world_height;

fn generate_noise() [world_width][world_height]f32 {
    const noisearray = [world_width][world_height]f32;
    @memset(&noisearray, 0);

    for (0..world_width) |x| {
        for (0..world_height) |y| {
            noisearray[x][y] = @mod(rand(), 1);
        }
    }
}
