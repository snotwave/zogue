const engine_state = @import("state.zig");
const vaxis = @import("vaxis");

pub fn handle_input(state: *engine_state.AppState, key: vaxis.Key) void {
    const map = state.world.map;
    const player = &state.world.entities[0];

    if (key.matches('q', .{})) {
        state.running = false;
    }
    if (key.matches(vaxis.Key.left, .{})) {
        if (player.dir == 0)
            player.dir = 7
        else
            player.dir -= 1;
    }
    if (key.matches(vaxis.Key.right, .{})) {
        if (player.dir == 7)
            player.dir = 0
        else
            player.dir += 1;
    }
    if (key.matches(vaxis.Key.up, .{})) {
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
    if (key.matches(vaxis.Key.down, .{})) {
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
}
