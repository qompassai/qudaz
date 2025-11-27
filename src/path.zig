//qompassai/qudaz/src/path.zig
// ----------------------------------------
// Copyright (C) 2025 Qompass AI, All rights reserved
pub const PathBuffer = struct {
    raw_path: []const u8,
    const Self = @This();

    fn new(path: []const u8) Self {
        return .{ .raw_path = path };
    }
};
