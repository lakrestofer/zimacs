const root = @import("../root.zig");
const Lexer = root.Lexer;
const Token = root.Token;
const cmod = Lexer.cmod;
const testLexer = @import("./utils.zig").testLexer;

test "parens" {
    try testLexer(&([_]Token{Token.init(cmod.L_PAREN, 0, 1)}), @ptrCast("("));
    try testLexer(&([_]Token{Token.init(cmod.R_PAREN, 0, 1)}), @ptrCast(")"));
    try testLexer(&([_]Token{Token.init(cmod.L_VEC_PAREN, 0, 2)}), @ptrCast("#("));
    try testLexer(&([_]Token{Token.init(cmod.L_BYTE_VEC_PAREN, 0, 4)}), @ptrCast("#u8("));
}
