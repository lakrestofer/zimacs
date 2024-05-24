// std lib imports
const std = @import("std");
// internal imports
pub const Token = @import("Token.zig");
pub const cmod = @import("clexer.zig");

// === fields begin ===
// struct Lexer {
buffer: [:0]const u8,
beginning: *const u8, // first element in the buffer
cursor: *const u8, // current element in the buffer
eof_reached: bool = false,
// }
// === fields end ===

const Self = @This();

// === methods begin ===
pub fn next_token(self: *Self) ?Token {
    if (self.eof_reached) {
        return null;
    }

    var token_kind: Token.TokenKind = cmod.INVALID;

    var token_begin = self.cursor;
    var token_end = self.cursor;
    // call into the state machine
    token_kind = cmod.next_token(@ptrCast(&token_begin), @ptrCast(&token_end));
    const start: usize = @intFromPtr(token_begin) - @intFromPtr(self.beginning);
    const end: usize = @intFromPtr(token_end) - @intFromPtr(self.beginning);
    self.cursor = token_end;

    if (token_kind == cmod.EOF) {
        self.eof_reached = true;
    }

    return Token{ .kind = token_kind, .location = .{ .start = start, .end = end } };
}

pub fn init(buffer: [:0]const u8) Self {
    return Self{ .buffer = buffer, .cursor = &buffer[0], .beginning = &buffer[0] };
}
// === methods end ===
