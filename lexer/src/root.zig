const std = @import("std");

pub const Lexer = @import("lexer/Lexer.zig");
pub const Token = Lexer.Token;
pub const TokenKind = Token.TokenKind;
pub const Location = Token.Location;
pub const cmod = Lexer.cmod;

test {
    _ = @import("lexer/Token.zig");
}

fn testLexer(tokens: []const Token, input: [:0]const u8) !void {
    var l = Lexer.init(input);
    for (tokens) |token| try std.testing.expectEqual(token, l.next_token().?);
}

test "parens" {
    try testLexer(&([_]Token{Token.init(cmod.L_PAREN, 0, 1)}), @ptrCast("("));
    try testLexer(&([_]Token{Token.init(cmod.R_PAREN, 0, 1)}), @ptrCast(")"));
    try testLexer(&([_]Token{Token.init(cmod.L_VEC_PAREN, 0, 2)}), @ptrCast("#("));
}

test "skipped tokens" {
    try testLexer(&([_]Token{Token.init(cmod.L_PAREN, 1, 2)}), @ptrCast(" (   "));
    try testLexer(
        &([_]Token{
            Token.init(cmod.L_PAREN, 20, 21),
            Token.init(cmod.R_PAREN, 21, 22),
        }),
        @ptrCast("; this is a comment\n()"),
    );
}

test "litterals" {
    try testLexer(&([_]Token{Token.init(cmod.STRING, 0, 18)}), @ptrCast("\"this is a string\""));
}

test "small input" {
    const input = "(add one two)";
    var lexer: Lexer = Lexer.init(input);

    var expected: [6]Token = undefined;
    expected[0] = Token{ .kind = cmod.L_PAREN, .location = .{ .start = 0, .end = 1 } };
    expected[1] = Token{ .kind = cmod.IDENTIFIER, .location = .{ .start = 1, .end = 4 } };
    expected[2] = Token{ .kind = cmod.IDENTIFIER, .location = .{ .start = 5, .end = 8 } };
    expected[3] = Token{ .kind = cmod.IDENTIFIER, .location = .{ .start = 9, .end = 12 } };
    expected[4] = Token{ .kind = cmod.R_PAREN, .location = .{ .start = 12, .end = 13 } };
    expected[5] = Token{ .kind = cmod.EOF, .location = .{ .start = 13, .end = 14 } };

    try std.testing.expectEqual(expected[0], lexer.next_token().?);
    try std.testing.expectEqualSlices(u8, "(", input[expected[0].location.start..expected[0].location.end]);

    try std.testing.expectEqual(expected[1], lexer.next_token().?);
    try std.testing.expectEqualSlices(u8, "add", input[expected[1].location.start..expected[1].location.end]);

    try std.testing.expectEqual(expected[2], lexer.next_token().?);
    try std.testing.expectEqualSlices(u8, "one", input[expected[2].location.start..expected[2].location.end]);

    try std.testing.expectEqual(expected[3], lexer.next_token().?);
    try std.testing.expectEqualSlices(u8, "two", input[expected[3].location.start..expected[3].location.end]);

    try std.testing.expectEqual(expected[4], lexer.next_token().?);
    try std.testing.expectEqualSlices(u8, ")", input[expected[4].location.start..expected[4].location.end]);

    try std.testing.expectEqual(expected[5], lexer.next_token().?);
}
