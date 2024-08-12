const world = @import("world.zig");
const entity = @import("entities.zig");

const car_dist = @import("functions.zig").cartesian_distance;
const euc_dist = @import("functions.zig").euc_dist;

const radius: usize = 4;

pub fn draw_fov(world_state: *world.World) void {
    const player: entity.Entity = world_state.entities[0];

    for (0..world.world_width - radius) |x| {
        for (0..world.world_height - radius) |y| {
            if ((car_dist(player.xpos, player.ypos, x, y)) <= radius) {
                //if ((euc_dist(player.xpos, x) <= radius) and (euc_dist(player.ypos, y) <= radius)) {
                world_state.map[x][y].visible = true;
                world_state.map[x][y].revealed = true;
            } else {
                world_state.map[x][y].visible = false;
            }
        }
    }
}
