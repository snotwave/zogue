const std = @import("std");
const vaxis = @import("vaxis");

const entity = @import("entities.zig");
const input = @import("input.zig");
const world = @import("world.zig");
const ui = @import("../ui/ui.zig");

const Event = union(enum) {
    key_press: vaxis.Key,
    winsize: vaxis.Winsize,
};

pub const AppState = struct {
    allocator: std.mem.Allocator,
    running: bool,
    terminal: vaxis.Tty,
    instance: vaxis.Vaxis,
    world: world.World,

    pub fn init(allocator: std.mem.Allocator) !AppState {
        return .{
            .allocator = allocator,
            .running = true,
            .terminal = try vaxis.Tty.init(),
            .instance = try vaxis.init(allocator, .{}),
            .world = try world.World.init(),
        };
    }

    pub fn deinit(self: *AppState) void {
        self.instance.deinit(self.allocator, self.terminal.anyWriter());
        self.terminal.deinit();
    }

    pub fn run(self: *AppState) !void {
        var loop: vaxis.Loop(Event) = .{
            .tty = &self.terminal,
            .vaxis = &self.instance,
        };
        try loop.init();

        try loop.start();
        defer loop.stop();

        try self.instance.enterAltScreen(self.terminal.anyWriter());
        try self.instance.queryTerminal(self.terminal.anyWriter(), 1 * std.time.ns_per_s);
        try self.instance.setMouseMode(self.terminal.anyWriter(), true);

        while (self.running) {
            loop.pollEvent();
            while (loop.tryEvent()) |event| {
                try self.update(event);
            }
            self.draw();
            var buffered = self.terminal.bufferedWriter();
            try self.instance.render(buffered.writer().any());
            try buffered.flush();
        }
    }

    pub fn update(self: *AppState, event: Event) !void {
        switch (event) {
            .key_press => |key| {
                input.handle_input(self, key);
            },
            .winsize => |ws| try self.instance.resize(self.allocator, self.terminal.anyWriter(), ws),
        }
    }

    pub fn draw(self: *AppState) void {
        const win = self.instance.window();

        win.clear();

        self.world.draw(win);
        ui.draw_border(win);
    }
};
