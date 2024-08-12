const world = @import("world.zig");
const entity = @import("entities.zig");

const car_dist = @import("functions.zig").cartesian_distance;
const euc_dist = @import("functions.zig").euc_dist;
const sign_euc_dist = @import("functions.zig").sign_euc_dist;
const plus_sign = @import("functions.zig").plus_sign;

const radius: usize = 7;

pub fn draw_fov(world_state: *world.World) void {
    const player: entity.Entity = world_state.entities[0];

    for (0..world.world_width - radius) |x| {
        for (0..world.world_height - radius) |y| {
            if (car_dist(player.xpos, player.ypos, x, y) <= radius) {
                world_state.map[x][y].visible = true;
                world_state.map[x][y].revealed = true;
            } else {
                world_state.map[x][y].visible = false;
            }
        }
    }
}
