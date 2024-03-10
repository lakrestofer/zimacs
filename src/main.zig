const std = @import("std");

const io = std.io;
const process = std.process;
const fs = std.fs;
const mem = std.mem;

const File = std.fs.File;
const Allocator = std.mem.Allocator;

const lexer_mod = @import("lexer.zig");

const MAX_FILE_SIZE: usize = 1 << 24;

// internal imports

pub fn main() !void {
    var args = process.ArgIteratorPosix.init(); // we need access the number of args
    const stdout = std.io.getStdOut().writer();

    if (args.count == 1 or args.count > 2) {
        try stdout.print("usage: ./zimacs ./program.zl\n", .{});
        std.process.exit(1);
    }

    // get path to input file, cannot be empty (since we know we have 2 arguments)
    _ = args.next().?; // throw away the first arg (which is the path of this program)
    const input_path: [:0]const u8 = args.next().?;

    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // open file handle
    const cwd: fs.Dir = fs.cwd();
    const input_file: File = try cwd.openFile(input_path, File.OpenFlags{});
    defer input_file.close(); // close the mf file!

    // read in entire file in memory
    // and create zero terminated slice
    const input: [:0]u8 = try input_file.readToEndAllocOptions(allocator, MAX_FILE_SIZE, null, @alignOf(u8), 0);
    defer allocator.free(input);

    std.debug.print("input: {s}", .{input});

    // build
    var lexer: lexer_mod.Lexer = lexer_mod.new(input);

    while (lexer.next_token()) |token| {
        try stdout.print("{any}\n", .{token});
    }
}
