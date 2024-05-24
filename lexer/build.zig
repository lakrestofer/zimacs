const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // build options
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // generate c lexer
    const generate_lexer = b.addSystemCommand(&.{"re2c"});
    generate_lexer.addArgs(&.{"--utf8"});
    generate_lexer.addFileArg(.{ .path = "src/lexer/lexer.in.c" });
    generate_lexer.addArgs(&.{"--output"});
    const generated_lexer_src = generate_lexer.addOutputFileArg("tokenizer_sm.c");
    const gen_files = b.addWriteFiles();
    gen_files.addCopyFileToSource(generated_lexer_src, "src/lexer/lexer.c");

    // build c lexer
    const lexer_lib = b.addStaticLibrary(.{ .name = "tokenizer", .target = target, .optimize = optimize });
    lexer_lib.linkLibC();
    lexer_lib.addCSourceFiles(.{ .files = &.{"src/lexer/lexer.c"}, .flags = &.{ "-pedantic", "-Wall" } });
    lexer_lib.addIncludePath(.{ .path = "src/lexer/" });
    lexer_lib.step.dependOn(&gen_files.step);
    b.installArtifact(lexer_lib);

    // build library
    const lib = b.addStaticLibrary(.{
        .name = "lexer",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.linkLibrary(lexer_lib);
    lib.addIncludePath(.{ .path = "src/lexer" });
    b.installArtifact(lib);

    // build exe
    const exe = b.addExecutable(.{
        .name = "zimacs-lexer",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibC();
    exe.linkLibrary(lexer_lib);
    exe.addIncludePath(.{ .path = "src/lexer" });
    b.installArtifact(exe);

    // build tests
    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/root.zig" },
        .target = target,
        .optimize = optimize,
    });
    unit_tests.addIncludePath(.{ .path = "src/lexer/" });
    unit_tests.linkLibrary(lexer_lib);

    // run command
    const run_unit_tests_cmd = b.addRunArtifact(unit_tests);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // steps
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests_cmd.step);
}
