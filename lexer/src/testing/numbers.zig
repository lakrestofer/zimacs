// in this file we test the different types of number literals
const std = @import("std");
const root = @import("../root.zig");
const Lexer = root.Lexer;
const Token = root.Token;
const cmod = root.Lexer.cmod;
const testLexer = @import("./utils.zig").testLexer;

test "whaaaat" {
    try std.testing.expect(false);
}
