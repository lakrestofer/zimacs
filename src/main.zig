const std = @import("std");

const io = std.io;
const process = std.process;

const TokenKind = enum {
    OpenParen, // (
    CloseParen, // )
    Identifier,
};

const Token = struct {
    pos: usize,
    len: usize,
    tokenkind: TokenKind,
};

pub fn main() !void {
    var args = process.ArgIteratorPosix.init();
    const stdout = std.io.getStdOut().writer();
    if (args.count == 1 or args.count > 2) {
        try stdout.print("usage: ./zimacs ./program.zi\n", .{});
        std.process.exit(1);
    }
}
