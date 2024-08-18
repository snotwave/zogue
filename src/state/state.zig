const std = @import("std");
const vaxis = @import("vaxis");

const sa = @import("app/appstate.zig");
const ui = @import("ui/uistate.zig");

const sw = @import("world/worldstate.zig");

const in = @import("input.zig");

const c = @import("constants.zig");

const Event = union(enum) {
    key_press: vaxis.Key,
    winsize: vaxis.Winsize,
};

pub const State_All = struct {

    // handles all vaxis-related engine state
    state_app: sa.State_App,

    // handles all game-related engine state
    state_world: sw.State_World,

    // handles all ui-related engine state
    state_ui: ui.State_UI,
    allocator: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator) !State_All {
        const state_app = try sa.State_App.init(alloc);
        const state_world = try sw.State_World.init(alloc);
        const state_ui = try ui.State_UI.init(alloc);

        return .{
            .state_app = state_app,
            .state_world = state_world,
            .state_ui = state_ui,
            .allocator = alloc,
        };
    }

    pub fn deinit(self: *State_All) void {
        self.state_app.deinit();
        self.state_world.deinit();
        self.state_ui.deinit();
    }

    pub fn set(self: *State_All) !void {
        try self.state_ui.message_add("You have awoken in an alien world in a forest with a path. You hear the sound of a rushing river nearby.");
        try self.state_ui.message_add("Try using the arrow keys to move and shift to strafe. \n");
        try self.state_ui.message_add("Welcome to the world of Zogue!");
    }

    pub fn run(self: *State_All) !void {

        // boilerplate code from the vaxis repo
        var loop: vaxis.Loop(Event) = .{
            .tty = &self.state_app.terminal,
            .vaxis = &self.state_app.instance,
        };

        try loop.init();

        try loop.start();
        defer loop.stop();

        try self.state_app.instance.enterAltScreen(self.state_app.terminal.anyWriter());
        try self.state_app.instance.queryTerminal(self.state_app.terminal.anyWriter(), 1 * std.time.ns_per_s);
        try self.state_app.instance.setMouseMode(self.state_app.terminal.anyWriter(), true);

        while (self.state_app.running) {
            loop.pollEvent();

            while (loop.tryEvent()) |event| {
                try self.update(event);
            }

            try self.draw();

            var buffered = self.state_app.terminal.bufferedWriter();
            try self.state_app.instance.render(buffered.writer().any());
            try buffered.flush();
        }
    }

    pub fn draw(self: *State_All) !void {
        const root_win = self.state_app.instance.window();
        const win = root_win.child(.{
            .x_off = (root_win.width -% c.UI_WIDTH) / 2 - 1,
            .y_off = (root_win.height -% c.UI_HEIGHT) / 2 - 1,
            .width = .{ .limit = c.UI_WIDTH + 1 },
            .height = .{ .limit = c.UI_HEIGHT + 1 },
        });
        const msgwin = win.child(.{
            .x_off = 2,
            .y_off = 1 + c.VIEWBOX_HEIGHT + c.UI_GAP,
            .width = .{ .limit = c.VIEWBOX_WIDTH - 2 },
            .height = .{ .limit = c.VIEWBOX_HEIGHT },
        });
        //const current_layer = self.state_world.current_layer;

        // clear out window
        win.clear();

        // draw world state, which consists of whatever current world layer the player is on
        self.state_world.draw(win);

        // draw the ui
        try self.state_ui.draw(win, msgwin);
    }

    pub fn update(self: *State_All, event: Event) !void {
        switch (event) {
            .key_press => |key| {
                in.handle_input(self, key);
            },
            .winsize => |ws| try self.state_app.instance.resize(self.allocator, self.state_app.terminal.anyWriter(), ws),
        }
    }
};
