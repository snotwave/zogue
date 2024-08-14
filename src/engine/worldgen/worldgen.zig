const world = @import("../world.zig");
const tile = @import("../tiles.zig");
const worldgen_rects = @import("worldgen_rects.zig");
const worldgen_landscape = @import("worldgen_landscape.zig");

pub const Algorithm = enum {
    rects,
    landscape,
};

const world_width = world.world_width;
const world_height = world.world_height;
const algorithm: Algorithm = .landscape;

pub fn worldgen(map: *[world_width][world_height]tile.Tile) void {
    switch (algorithm) {
        .rects => worldgen_rects.worldgen(map),
        else => worldgen_landscape.worldgen(map),
    }
}
