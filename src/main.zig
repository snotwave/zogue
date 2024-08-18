const std = @import("std");
const vaxis = @import("vaxis");

const s = @import("state/state.zig");

pub const panic = vaxis.panic_handler;
pub const std_options: std.Options = .{
    .log_scope_levels = &.{
        .{ .scope = .vaxis, .level = .warn },
        .{ .scope = .vaxis_parser, .level = .warn },
    },
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) {
            std.log.err("memory leak", .{});
        }
    }
    const allocator = gpa.allocator();

    var engine = try s.State_All.init(allocator);
    defer engine.deinit();

    try engine.set();

    try engine.run();
}
