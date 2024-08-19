const vaxis = @import("vaxis");

const st = @import("state.zig");

const Key = vaxis.Key;

pub fn handle_input(state: *st.State_All, key: Key) !void {
    const map = state.state_world;

    if (key.matches('q', .{})) {
        state.state_app.running = false;
    }

    // tank controls
    if (key.matches(Key.left, .{})) {
        state.state_world.hero.rotate(-1);
    }

    if (key.matches(Key.right, .{})) {
        state.state_world.hero.rotate(1);
    }

    if (key.matches(Key.up, .{})) {
        switch (state.state_world.hero.dir) {
            0 => state.state_world.hero.move(map, 1, 0),
            1 => state.state_world.hero.move(map, 1, 1),
            2 => state.state_world.hero.move(map, 0, 1),
            3 => state.state_world.hero.move(map, -1, 1),
            4 => state.state_world.hero.move(map, -1, 0),
            5 => state.state_world.hero.move(map, -1, -1),
            6 => state.state_world.hero.move(map, 0, -1),
            7 => state.state_world.hero.move(map, 1, -1),
            else => return,
        }
    }

    if (key.matches(Key.down, .{})) {
        switch (state.state_world.hero.dir) {
            0 => state.state_world.hero.move(map, -1, 0),
            1 => state.state_world.hero.move(map, -1, -1),
            2 => state.state_world.hero.move(map, 0, -1),
            3 => state.state_world.hero.move(map, 1, -1),
            4 => state.state_world.hero.move(map, 1, 0),
            5 => state.state_world.hero.move(map, 1, 1),
            6 => state.state_world.hero.move(map, 0, 1),
            7 => state.state_world.hero.move(map, -1, 1),
            else => return,
        }
    }

    // standard controls
    if (key.matches(Key.left, .{ .shift = true })) {
        state.state_world.hero.move(map, -1, 0);
    }

    if (key.matches(Key.right, .{ .shift = true })) {
        state.state_world.hero.move(map, 1, 0);
    }
    if (key.matches(Key.up, .{ .shift = true })) {
        state.state_world.hero.move(map, 0, -1);
    }
    if (key.matches(Key.down, .{ .shift = true })) {
        state.state_world.hero.move(map, 0, 1);
    }
}
