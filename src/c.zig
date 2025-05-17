//qompassai/qudaz/src/c.zig
// ----------------------------------------
// Copyright (C) 2025 Qompass AI, All rights reserved

pub const cuda = @cImport({
    @cInclude("cuda.h");
});

pub const curand = @import("curand.zig");
pub const cuda_runtime = struct {
    pub extern fn cudaMalloc(devPtr: [*c]?*anyopaque, size: usize) c_uint;
};
pub const nvrtc = @cImport(@cInclude("nvrtc.h"));
