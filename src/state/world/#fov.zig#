const c = @import("../constants.zig");
const State_World = @import("worldstate.zig").State_World;

// some useful functions
const math = @import("std").math;
const dtr = math.degreesToRadians;
const round = math.round;
const lCast = math.lossyCast;

// half the max width of the fov cone
const view_fov: usize = c.VIEW_FOV;

// distance of the fov cone
const radius: usize = c.VIEW_RADIUS;

// clear all visible tiles
pub fn reset_fov(state: *State_World) void {
    for (0..c.WORLD_WIDTH) |x| {
        for (0..c.WORLD_HEIGHT) |y| {
            state.layers[state.current_layer].map[x][y].visible = false;
        }
    }
}

// cast rays from the hero and mark all tiles that they hit as seen
pub fn set_fov(state: *State_World) void {
    const dir = state.hero.dir;

    // defines minimum and maximum degree of view cone
    var mindir: f32 = @floatFromInt((360 + (dir * 45)) - view_fov);
    const maxdir: f32 = mindir + (2 * view_fov);

    // tile player is standing on is always visible
    state.layers[state.current_layer].map[state.hero.xpos][state.hero.ypos].visible = true;

    while (mindir <= maxdir) : (mindir += 1) {
        const ax = @cos(dtr(mindir));
        const ay = @sin(dtr(mindir));

        var player_x: f32 = @floatFromInt(state.hero.xpos);
        var player_y: f32 = @floatFromInt(state.hero.ypos);

        var i: usize = 0;
        while (i < radius) : (i += 1) {
            player_x += ax;
            player_y += ay;

            if (player_x < 0 or player_y < 0) break;

            const ux: usize = lCast(usize, round(player_x));
            const uy: usize = lCast(usize, round(player_y));

            if (ux >= c.WORLD_WIDTH or uy >= c.WORLD_HEIGHT) {
                break;
            }

            state.layers[state.current_layer].map[ux][uy].visible = true;
            if (state.layers[state.current_layer].map[ux][uy].block_vision == true) {
                break;
            }
        }
    }
}

pub fn update_fov(state: *State_World) void {
    reset_fov(state);
    set_fov(state);
}
