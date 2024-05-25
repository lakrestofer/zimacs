// in this file we test the different types of number literals
const std = @import("std");
const root = @import("../root.zig");
const Lexer = root.Lexer;
const Token = root.Token;
const cmod = root.Lexer.cmod;
const testLexer = @import("./utils.zig").testLexer;

test "infnan" {
    try testLexer(
        &([_]Token{
            Token.init(cmod.NUMBER, 0, 6),
            Token.init(cmod.NUMBER, 7, 13),
            Token.init(cmod.NUMBER, 14, 20),
            Token.init(cmod.NUMBER, 21, 27),
        }),
        "+inf.0 -inf.0 +nan.0 -nan.0",
    );
}

test "binary" {
    try testLexer(&([_]Token{Token.init(cmod.NUMBER, 0, 10)}), "#b01010101");
    ok fortsätt här! vi behöver fixa ett bra sätt för invalid tokens att hanteras
    try testLexer(&([_]Token{Token.init(cmod.INVALID, 0, 1)}), "#b02");
}
test "octal" {
    try testLexer(&([_]Token{Token.init(cmod.NUMBER, 0, 10)}), "#o07070707");
    // try testLexer(&([_]Token{Token.init(cmod.INVALID, 0, 10)}), "#o08080808");
}

test "decimal" {
    try testLexer(
        &([_]Token{
            Token.init(cmod.NUMBER, 0, 10),
        }),
        "#o01010101",
    );
}
