// std lib imports
const std = @import("std");
// internal imports
const lexer_c = @import("clexer.zig");

// exported type definitions
pub const TokenKind = lexer_c.TokenKind;
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
pub fn format_kind(self: Self) []const u8 {
    return switch (self.kind) {
        lexer_c.INVALID => "INVALID",
        lexer_c.EOF => "EOF",
        lexer_c.IDENTIFIER => "IDENTIFIER",
        lexer_c.L_PAREN => "L_PAREN",
        lexer_c.R_PAREN => "R_PAREN",
        else => "WHAT_THE_ACTUAL_FUCK_HAVE_YOU_DONE_THIS_SHOULD_BE_IMPOSSIBLE",
    };
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
