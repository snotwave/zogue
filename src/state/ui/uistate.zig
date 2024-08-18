const std = @import("std");
const vaxis = @import("vaxis");
const ui = @import("ui.zig");

const join = @import("std").mem.join;

pub const State_UI = struct {
    allocator: std.mem.Allocator,
    messages: std.ArrayList([]const u8),
    messagelist: []const u8 = "",

    pub fn init(alloc: std.mem.Allocator) !State_UI {
        const messages = std.ArrayList([]const u8).init(alloc);

        return .{
            .allocator = alloc,
            .messages = messages,
        };
    }

    pub fn deinit(self: *State_UI) void {
        self.messages.deinit();
        self.allocator.free(self.messagelist);
    }

    pub fn draw(self: *State_UI, full_window: vaxis.Window, message_window: vaxis.Window) !void {
        ui.draw_border(full_window);

        try self.messages_draw(message_window);
    }

    pub fn message_add(self: *State_UI, message: []const u8) !void {
        try self.messages.append(message);
    }

    pub fn messages_draw(self: *State_UI, window: vaxis.Window) !void {
        // free the previously allocated slice consisting of the last 8 messages in the messages arraylist
        self.allocator.free(self.messagelist);

        // concatenates the last 8 messages in the messages arraylist into a flat array of slices
        var last_8_messages: [8][]const u8 = undefined;
        for (0..8) |i| {
            if (self.messages.items.len > i)
                last_8_messages[i] = self.messages.items[self.messages.items.len - i - 1]
            else
                last_8_messages[i] = "";
        }

        // concatenates the flat array of slices into a single slice delimited by newlines and stores it in the struct
        self.messagelist = try join(self.allocator, "\n", &last_8_messages);

        // print the message
        _ = try window.printSegment(.{ .text = self.messagelist }, .{});
    }
};
