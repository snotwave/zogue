const Tile = @import("../../objects/tile.zig").Tile;
const World = @import("worldstate.zig").World;

const c = @import("../constants.zig");

pub fn worldgen(map: *[c.WORLD_WIDTH][c.WORLD_HEIGHT]Tile) void {
    for (0..c.WORLD_WIDTH) |x| {
        for (0..c.WORLD_HEIGHT) |y| {
            if (x == 0 or x == c.WORLD_WIDTH - 1 or y == 0 or y == c.WORLD_HEIGHT - 1) {
                map[x][y].update(.wall_tree);
            } else map[x][y].update(.floor_standard);
        }
    }
}
