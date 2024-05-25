const root = @import("../root.zig");
const Lexer = root.Lexer;
const Token = root.Token;
const cmod = Lexer.cmod;
const testLexer = @import("./utils.zig").testLexer;

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
