const engine_state = @import("state.zig");
const vaxis = @import("vaxis");

const Key = vaxis.Key;

pub fn handle_input(state: *engine_state.AppState, key: Key) void {
    const current_layer = state.current_layer;

    const map = state.worlds[current_layer].map;
    const player = &state.worlds[current_layer].entities[0];

    if (key.matches('q', .{})) {
        state.running = false;
    }

    if (key.matches('l', .{})) {
        state.current_layer += 1;
    }

    // tank controls
    if (key.matches(Key.left, .{})) {
        if (player.dir == 0)
            player.dir = 7
        else
            player.dir -= 1;
    }
    if (key.matches(Key.right, .{})) {
        if (player.dir == 7)
            player.dir = 0
        else
            player.dir += 1;
    }
    if (key.matches(Key.up, .{})) {
        switch (player.dir) {
            0 => if (map[player.xpos + 1][player.ypos].block_movement == false) {
                player.xpos += 1;
            },
            1 => if (map[player.xpos + 1][player.ypos + 1].block_movement == false) {
                player.xpos += 1;
                player.ypos += 1;
            },
            2 => if (map[player.xpos][player.ypos + 1].block_movement == false) {
                player.ypos += 1;
            },
            3 => if (map[player.xpos - 1][player.ypos + 1].block_movement == false) {
                player.xpos -= 1;
                player.ypos += 1;
            },
            4 => if (map[player.xpos - 1][player.ypos].block_movement == false) {
                player.xpos -= 1;
            },
            5 => if (map[player.xpos - 1][player.ypos - 1].block_movement == false) {
                player.xpos -= 1;
                player.ypos -= 1;
            },
            6 => if (map[player.xpos][player.ypos - 1].block_movement == false) {
                player.ypos -= 1;
            },
            7 => if (map[player.xpos + 1][player.ypos - 1].block_movement == false) {
                player.xpos += 1;
                player.ypos -= 1;
            },
            else => {},
        }
    }
    if (key.matches(Key.down, .{})) {
        switch (player.dir) {
            0 => if (map[player.xpos - 1][player.ypos].block_movement == false) {
                player.xpos -= 1;
            },
            1 => if (map[player.xpos - 1][player.ypos - 1].block_movement == false) {
                player.xpos -= 1;
                player.ypos -= 1;
            },
            2 => if (map[player.xpos][player.ypos - 1].block_movement == false) {
                player.ypos -= 1;
            },
            3 => if (map[player.xpos + 1][player.ypos - 1].block_movement == false) {
                player.xpos += 1;
                player.ypos -= 1;
            },
            4 => if (map[player.xpos + 1][player.ypos].block_movement == false) {
                player.xpos += 1;
            },
            5 => if (map[player.xpos + 1][player.ypos + 1].block_movement == false) {
                player.xpos += 1;
                player.ypos += 1;
            },
            6 => if (map[player.xpos][player.ypos + 1].block_movement == false) {
                player.ypos += 1;
            },
            7 => if (map[player.xpos - 1][player.ypos + 1].block_movement == false) {
                player.xpos -= 1;
                player.ypos += 1;
            },
            else => {},
        }
    }

    // absolute controls/strafing
    if (key.matches(Key.down, .{ .ctrl = true })) {
        if (map[player.xpos][player.ypos + 1].block_movement == false)
            player.ypos += 1;
    }
    if (key.matches(Key.up, .{ .ctrl = true })) {
        if (map[player.xpos][player.ypos - 1].block_movement == false)
            player.ypos -= 1;
    }
    if (key.matches(Key.right, .{ .ctrl = true })) {
        if (map[player.xpos + 1][player.ypos].block_movement == false)
            player.xpos += 1;
    }
    if (key.matches(Key.left, .{ .ctrl = true })) {
        if (map[player.xpos - 1][player.ypos].block_movement == false)
            player.xpos -= 1;
    }
}
