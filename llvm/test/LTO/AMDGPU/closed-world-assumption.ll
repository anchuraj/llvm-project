; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -O3 -debug-only=amdgpu-attributor -o - %s 2>&1 | FileCheck %s --check-prefixes=NO-CW,NO-LTO
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -passes="lto<O3>" -debug-only=amdgpu-attributor -o - %s 2>&1 | FileCheck %s --check-prefixes=NO-CW,LTO
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -passes="lto<O3>" -debug-only=amdgpu-attributor -amdgpu-link-time-closed-world=1 -o - %s 2>&1 | FileCheck %s --check-prefixes=CW,LTO

; REQUIRES: amdgpu-registered-target
; REQUIRES: asserts

; NO-LTO: Running at phase None
; LTO: Running at phase FullLTOPostLink
; NO-CW: Module {{.*}} is not assumed to be a closed world.
; CW: Module {{.*}} is assumed to be a closed world.
define hidden noundef i32 @_Z3foov() {
  ret i32 1
}
