// std lib imports
const std = @import("std");
// internal imports
const c = @import("clexer.zig");

// exported type definitions
pub const TokenKind = c.TokenKind;
pub const Location = struct {
    start: usize,
    end: usize,
};

// === fields begin ===
// struct Token {
kind: TokenKind,
location: Location,
// }
// === fields end ===

const Self = @This();

// === methods begin ===
pub fn init(kind: TokenKind, start: usize, end: usize) Self {
    return Self{ .kind = kind, .location = .{ .start = start, .end = end } };
}

pub fn format_kind(self: Self) []const u8 {
    const c_slice: c.Slice = c.format_kind(self.kind);
    const slice = c_slice.ptr[0..c_slice.len];
    return slice;
}

pub fn format(
    self: Self,
    comptime fmt: []const u8,
    options: std.fmt.FormatOptions,
    writer: anytype,
) !void {
    _ = fmt;
    _ = options;

    try writer.print("Token {{ kind = {s} }}", .{self.format_kind()});
}
// === methods begin ===

test "format enum variant" {
    try std.testing.expectEqualSlices(u8, "INVALID", Self.init(c.INVALID, 0, 0).format_kind());
    try std.testing.expectEqualSlices(u8, "EOF", Self.init(c.EOF, 0, 0).format_kind());
    try std.testing.expectEqualSlices(u8, "IDENTIFIER", Self.init(c.IDENTIFIER, 0, 0).format_kind());
    try std.testing.expectEqualSlices(u8, "L_PAREN", Self.init(c.L_PAREN, 0, 0).format_kind());
    try std.testing.expectEqualSlices(u8, "R_PAREN", Self.init(c.R_PAREN, 0, 0).format_kind());
}
