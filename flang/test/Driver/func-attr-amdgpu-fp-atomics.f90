! RUN: %flang_fc1 -emit-llvm -triple amdgcn-amd-amdhsa -munsafe-fp-atomics %s -o - | FileCheck %s 

subroutine func
end subroutine func

! CHECK: "amdgpu-unsafe-fp-atomics"="true"
