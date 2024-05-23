// std lib imports
const std = @import("std");
// internal imports
pub const Token = @import("Token.zig");
pub const c = @import("clexer.zig");

// === fields begin ===
// struct Lexer {
buffer: [:0]const u8,
cursor: *const u8,
position: usize = 0,
eof_reached: bool = false,
// }
// === fields end ===

const Self = @This();

// === methods begin ===
pub fn next_token(self: *Self) ?Token {
    if (self.eof_reached) {
        return null;
    }

    var token_kind: Token.TokenKind = c.INVALID;

    token_kind = c.next_token(@ptrCast(&self.cursor));

    if (token_kind == c.EOF) {
        self.eof_reached = true;
    }

    return Token{ .kind = token_kind, .location = .{ .start = 0, .end = 0 } };
}

pub fn init(buffer: [:0]const u8) Self {
    return Self{ .buffer = buffer, .cursor = &buffer[0] };
}
// === methods begin ===
