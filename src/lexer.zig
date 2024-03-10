const std = @import("std");

pub const lexer_c = @cImport(@cInclude("lexer.h"));

pub const TokenKind = lexer_c.TokenKind;

pub const Token = struct {
    kind: TokenKind,
    location: Location,

    pub const Location = struct {
        start: usize,
        end: usize,
    };

    const Self = @This();

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
};

pub const Lexer = struct {
    buffer: [:0]const u8,
    cursor: *const u8,
    position: usize = 0,
    eof_reached: bool = false,

    const Self = @This();

    pub fn next_token(self: *Lexer) ?Token {
        if (self.eof_reached) {
            return null;
        }

        var token_kind: TokenKind = lexer_c.INVALID;

        token_kind = lexer_c.next_token(@ptrCast(&self.cursor));

        if (token_kind == lexer_c.EOF) {
            self.eof_reached = true;
        }

        return Token{ .kind = token_kind, .location = .{ .start = 0, .end = 0 } };
    }
};

pub fn new(buffer: [:0]const u8) Lexer {
    return Lexer{ .buffer = buffer, .cursor = &buffer[0] };
}
