const std = @import("std");
const vaxis = @import("vaxis");

const color = @import("../../colors.zig");

const Hero = @import("../../objects/hero.zig").Hero;
const State = @import("../state.zig").State_All;

pub const hero_data_strings = struct {
    hero_level: []const u8 = "",
    hero_health_current: []const u8 = "",
    hero_health_max: []const u8 = "",
    hero_experience_current: []const u8 = "",
    hero_experience_max: []const u8 = "",
};

pub fn usize_to_slice(arg_int: usize, allocator: std.mem.Allocator) ![]const u8 {
    return try std.fmt.allocPrint(allocator, "{}", .{arg_int});
}

pub fn update_stats(state: *State, stats: *hero_data_strings) !void {
    const hero: Hero = state.state_world.hero;

    state.allocator.free(stats.hero_level);
    stats.hero_level = try usize_to_slice(hero.level_current, state.allocator);

    state.allocator.free(stats.hero_health_current);
    stats.hero_health_current = try usize_to_slice(hero.health_current, state.allocator);

    state.allocator.free(stats.hero_health_max);
    stats.hero_health_max = try usize_to_slice(hero.health_maximum, state.allocator);

    state.allocator.free(stats.hero_experience_current);
    stats.hero_experience_current = try usize_to_slice(hero.xp_current, state.allocator);

    state.allocator.free(stats.hero_experience_max);
    stats.hero_experience_max = try usize_to_slice(hero.xp_maximum, state.allocator);
}

pub fn draw_stats(state: *State, stats: *hero_data_strings, window: vaxis.Window) !void {
    const hero: Hero = state.state_world.hero;

    try update_stats(state, stats);

    const hero_name: []const u8 = hero.name;

    const title_style: vaxis.Cell.Style = .{
        .bold = true,
    };
    const subtitle_style: vaxis.Cell.Style = .{
        .italic = true,
    };

    const health_style: vaxis.Cell.Style = .{ .italic = true, .fg = color.red };
    const xp_style: vaxis.Cell.Style = .{ .italic = true, .fg = color.dark_yellow };

    _ = try window.print(&.{
        .{ .text = hero_name, .style = title_style },
        .{ .text = "\nLevel ", .style = subtitle_style },
        .{ .text = stats.hero_level, .style = subtitle_style },

        // draw and format health
        .{ .text = "\n \nHealth \n", .style = title_style },
        .{ .text = stats.hero_health_current, .style = health_style },
        .{ .text = " / ", .style = subtitle_style },
        .{ .text = stats.hero_health_max, .style = health_style },

        // draw and format xp
        .{ .text = "\n \nExperience \n", .style = title_style },
        .{ .text = stats.hero_experience_current, .style = xp_style },
        .{ .text = " / ", .style = subtitle_style },
        .{ .text = stats.hero_experience_max, .style = xp_style },
    }, .{});
}
