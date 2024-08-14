const world = @import("world.zig");
const entity = @import("entities.zig");

const car_dist = @import("functions.zig").cartesian_distance;
const euc_dist = @import("functions.zig").euc_dist;
const sign_euc_dist = @import("functions.zig").sign_euc_dist;
const plus_sign = @import("functions.zig").plus_sign;

const math = @import("std").math;
const dtr = math.degreesToRadians;
const round = math.round;
const lossyCast = math.lossyCast;

const view_fov: usize = 45;
const radius: usize = 32;

pub fn reset_fov(world_state: *world.World) void {
    for (0..world.world_width) |x| {
        for (0..world.world_height) |y| {
            world_state.map[x][y].visible = false;
        }
    }
}

pub fn set_fov(world_state: *world.World) void {
    const player = world_state.entities[0];

    const mindir = (360 + ((player.dir) * 45) - view_fov);
    const maxdir: f32 = @floatFromInt(mindir + 2 * view_fov);

    var dir: f32 = @floatFromInt(mindir);

    world_state.map[player.xpos][player.ypos].visible = true;

    while (dir <= maxdir) : (dir += 0.09) {
        const ax = @cos(dtr(dir));
        const ay = @sin(dtr(dir));

        var player_x: f32 = @floatFromInt(player.xpos);
        var player_y: f32 = @floatFromInt(player.ypos);

        var i: usize = 0;
        while (i < radius) : (i += 1) {
            player_x += ax;
            player_y += ay;

            if (player_x < 0 or player_y < 0) break;

            const ux: usize = lossyCast(usize, round(player_x));
            const uy: usize = lossyCast(usize, round(player_y));

            if (ux > world.world_width or uy > world.world_height) {
                break;
            }

            world_state.map[ux][uy].visible = true;
            if (world_state.map[ux][uy].block_vision == true) {
                break;
            }
        }
    }
}

pub fn draw_fov(world_state: *world.World) void {
    reset_fov(world_state);
    set_fov(world_state);
}

//pub fn draw_fov(world_state: *world.World) void {
//    const player: entity.Entity = world_state.entities[0];
//
//    for (0..world.world_width) |x| {
//        for (0..world.world_height) |y| {
//            if (has_fov(player, world_state, x, y)) {
//                //if (car_dist(player.xpos, player.ypos, x, y) <= radius) {
//                world_state.map[x][y].visible = true;
//                world_state.map[x][y].revealed = true;
//            } else {
//                world_state.map[x][y].visible = false;
//            }
//        }
//    }
//}
