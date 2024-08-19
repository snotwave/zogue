const std = @import("std");
const vaxis = @import("vaxis");

const st = @import("../state.zig");
const ui = @import("ui.zig");
const c = @import("../constants.zig");
const sidebar = @import("sidebar.zig");
const message = @import("messages.zig");

const join = @import("std").mem.join;

pub const State_UI = struct {
    allocator: std.mem.Allocator,
    messages: std.ArrayList(message.message),
    stats: sidebar.hero_data_strings = .{},

    pub fn init(alloc: std.mem.Allocator) !State_UI {
        const messages = std.ArrayList(message.message).init(alloc);

        return .{
            .allocator = alloc,
            .messages = messages,
        };
    }

    pub fn deinit(self: *State_UI) void {

        // clear messages arraylist
        self.messages.deinit();

        // clear stats struct (there's probably a nicer way to do this)
        self.allocator.free(self.stats.hero_level);
        self.allocator.free(self.stats.hero_health_current);
        self.allocator.free(self.stats.hero_health_max);
        self.allocator.free(self.stats.hero_experience_current);
        self.allocator.free(self.stats.hero_experience_max);
    }

    pub fn draw(self: *State_UI, state: *st.State_All, full_window: vaxis.Window, message_window: vaxis.Window, sidebar_window: vaxis.Window) !void {
        ui.draw_border(full_window);

        try self.messages_draw(message_window);
        try sidebar.draw_stats(state, &self.stats, sidebar_window);
    }

    pub fn message_add(self: *State_UI, mess: message.message) !void {
        try self.messages.append(mess);
    }

    pub fn messages_draw(self: *State_UI, window: vaxis.Window) !void {
        var last_messages: []vaxis.Segment = try self.allocator.alloc(vaxis.Segment, c.UI_MAX_MESSAGES);
        defer self.allocator.free(last_messages);

        for (0..c.UI_MAX_MESSAGES) |i| {
            if (self.messages.items.len > i) {
                const this_message = self.messages.items[self.messages.items.len - i - 1];

                last_messages[i] = .{ .text = this_message.message, .style = this_message.style };
            } else last_messages[i] = .{ .text = "" };
        }

        _ = try window.print(last_messages, .{});
    }
};
