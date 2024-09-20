const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const llhttp = b.dependency("llhttp", .{ .target = target, .optimize = optimize });

    const lib = b.addStaticLibrary(.{
        .name = "llhttp-zig",

        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib.linkLibC();

    lib.addIncludePath(llhttp.path("include"));
    const header_path = llhttp.path("include/llhttp.h");
    lib.installHeader(header_path, "llhttp.h");

    // Add in all the source files from llhtpp
    lib.addCSourceFile(.{ .file = llhttp.path("src/api.c") });
    lib.addCSourceFile(.{ .file = llhttp.path("src/http.c") });
    lib.addCSourceFile(.{ .file = llhttp.path("src/llhttp.c") });

    b.installArtifact(lib);
}
