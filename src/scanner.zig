const std = @import("std");

pub fn Scanner(comptime ReaderType: type) type {
    return struct {
        const Self = @This();

        input: ReaderType,

        buffer: [1048]u8,

        pub fn nextChar(self: Self) ?u8 {
            _ = self;

            return null;
        }
    };
}

pub fn scanner(reader: anytype) Scanner(@TypeOf(reader)) {
    return .{
        .input = reader,
        .buffer = undefined,
    };
}
pub const TokenKind = enum {
    OpenParen, // (
    CloseParen, // )
    Identifier,
};

pub const Token = struct {
    pos: usize,
    len: usize,
    tokenkind: TokenKind,
};
