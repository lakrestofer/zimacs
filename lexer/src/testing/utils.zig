// std lib imports
const std = @import("std");
// internal imports
const root = @import("../root.zig");
const Lexer = root.Lexer;
const Token = Lexer.Token;
const TokenKind = Token.TokenKind;
const Location = Token.Location;

pub fn testLexer(tokens: []const Token, input: [:0]const u8) !void {
    var l = Lexer.init(input);
    for (tokens) |token| try std.testing.expectEqual(token, l.next_token().?);
}
