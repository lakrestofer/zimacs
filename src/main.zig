const std = @import("std");

const io = std.io;
const process = std.process;
const fs = std.fs;
const mem = std.mem;

const File = std.fs.File;
const Allocator = std.mem.Allocator;

// internal imports

pub fn main() !void {
    var args = process.ArgIteratorPosix.init(); // we need access the number of args
    const stdout = std.io.getStdOut().writer();

    if (args.count == 1 or args.count > 2) {
        try stdout.print("usage: ./zimacs ./program.zi\n", .{});
        std.process.exit(1);
    }

    // get path to input file, cannot be empty (since we know we have 2 arguments)
    const input_path: [:0]const u8 = args.next().?;

    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    _ = allocator;
    defer _ = gpa.deinit();

    // open file handle
    const cwd: fs.Dir = fs.cwd();
    const input_file: File = try cwd.openFile(input_path, File.OpenFlags{});
    defer input_file.close();

    // read in entire file in memory
    const reader = input_file.reader();
    _ = reader;
}
