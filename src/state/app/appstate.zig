const std = @import("std");
const vaxis = @import("vaxis");

pub const State_App = struct {
    allocator: std.mem.Allocator,
    running: bool,
    terminal: vaxis.Tty,
    instance: vaxis.Vaxis,

    pub fn init(allocator: std.mem.Allocator) !State_App {
        return .{
            .allocator = allocator,
            .running = true,
            .terminal = try vaxis.Tty.init(),
            .instance = try vaxis.init(allocator, .{}),
        };
    }

    pub fn deinit(self: *State_App) void {
        self.instance.deinit(self.allocator, self.terminal.anyWriter());
        self.terminal.deinit();
    }
};
