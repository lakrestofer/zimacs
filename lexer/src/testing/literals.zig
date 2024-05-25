const root = @import("../root.zig");
const Lexer = root.Lexer;
const Token = root.Token;
const cmod = root.Lexer.cmod;
const testLexer = @import("./utils.zig").testLexer;

test "literals" {
    try testLexer(&([_]Token{Token.init(cmod.STRING, 0, 18)}), @ptrCast("\"this is a string\""));
}
