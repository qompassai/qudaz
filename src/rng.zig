//qompassai/qudaz/src/rng.zig
// ----------------------------------------
// Copyright (C) 2025 Qompass AI, All rights reserved
const c = @import("c.zig");
const Error = @import("error.zig");
const CudaSlice = @import("wrappers.zig").CudaSlice;
const Device = @import("device.zig");
const std = @import("std");
const DEFAULT_SEED = 0;

rng: c.curand.curandGenerator_t,
device: Device,

pub fn default() !@This() {
    var local_rng: c.curand.curandGenerator_t = undefined;
    try Error.fromCurandErrorCode(c.curand.curandCreateGenerator(&local_rng, c.curand.CURAND_RNG_PSEUDO_DEFAULT));
    try Error.fromCurandErrorCode(c.curand.curandSetPseudoRandomGeneratorSeed(local_rng, DEFAULT_SEED));
    return .{ .rng = local_rng, .device = try Device.default() };
}

pub fn init(device: Device, seed: ?u64) !@This() {
    var local_rng: c.curand.curandGenerator_t = undefined;
    try Error.fromCurandErrorCode(c.curand.curandCreateGenerator(&local_rng, c.curand.CURAND_RNG_PSEUDO_DEFAULT));
    try Error.fromCurandErrorCode(c.curand.curandSetPseudoRandomGeneratorSeed(local_rng, seed orelse DEFAULT_SEED));
    return .{ .rng = local_rng, .device = device };
}

pub fn genrandom(self: @This(), size: usize) !CudaSlice(f32) {
    var slice_ptr: *f32 = undefined;
    try Error.fromCurandErrorCode(c.cuda_runtime.cudaMalloc(@ptrCast(&slice_ptr), @sizeOf(f32) * size));
    try Error.fromCurandErrorCode(c.curand.curandGenerateUniform(self.rng, slice_ptr, size));
    return .{ .device_ptr = @intFromPtr(slice_ptr), .len = size, .device = self.device };
}
