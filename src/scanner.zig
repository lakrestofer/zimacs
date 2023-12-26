const std = @import("std");
const Reader = std.io.Reader;

pub fn Scanner(comptime reader: type) type {
    return struct {
        const Self = @This();
        input: @TypeOf(reader),

        buffer: [1048]u8,

        pub fn new(input: Reader) Self {
            return Self{
                .input = input,
            };
        }

        pub fn nextChar(self: Scanner) ?u8 {
            _ = self;

            return null;
        }
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
