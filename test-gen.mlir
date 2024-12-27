
module attributes {dlti.dl_spec = #dlti.dl_spec<f16 = dense<16> : vector<2xi64>, f128 = dense<128> : vector<2xi64>, !llvm.ptr<270> = dense<32> : vector<4xi64>, f64 = dense<64> : vector<2xi64>, !llvm.ptr<271> = dense<32> : vector<4xi64>, !llvm.ptr<272> = dense<64> : vector<4xi64>, i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, f80 = dense<128> : vector<2xi64>, !llvm.ptr = dense<64> : vector<4xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, "dlti.stack_alignment" = 128 : i64, "dlti.endianness" = "little">, fir.defaultkind = "a1c4d8i4l4r4", fir.kindmap = "", llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", llvm.ident = "flang version 20.0.0 (git@github.com:anchuraj/llvm-project.git aedc369685b22e2b8f7413557d292a78637f563b)", llvm.target_triple = "x86_64-unknown-linux-gnu", omp.is_gpu = false, omp.is_target_device = false, omp.target_triples = [], omp.version = #omp.version<version = 11>} {
  omp.declare_reduction @add_reduction_i32 : i32 init {
  ^bb0(%arg0: i32):
    %0 = llvm.mlir.constant(0 : i32) : i32
    omp.yield(%0 : i32)
  } combiner {
  ^bb0(%arg0: i32, %arg1: i32):
    %0 = llvm.add %arg0, %arg1 : i32
    omp.yield(%0 : i32)
  }
  llvm.func @_QQmain() attributes {fir.bindc_name = "inclusive_scan"} {
    %0 = llvm.mlir.constant(1 : i64) : i64
    %1 = llvm.alloca %0 x i32 {bindc_name = "z"} : (i64) -> !llvm.ptr
    %2 = llvm.mlir.constant(1 : i64) : i64
    %3 = llvm.alloca %2 x i32 {bindc_name = "y"} : (i64) -> !llvm.ptr
    %4 = llvm.mlir.constant(1 : i64) : i64
    %5 = llvm.alloca %4 x i32 {bindc_name = "x"} : (i64) -> !llvm.ptr
    %6 = llvm.mlir.constant(1 : i64) : i64
    %7 = llvm.alloca %6 x i32 {bindc_name = "k"} : (i64) -> !llvm.ptr
    %8 = llvm.mlir.constant(0 : index) : i64
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.mlir.constant(100 : i32) : i32
    %11 = llvm.mlir.constant(1 : i32) : i32
    %12 = llvm.mlir.constant(0 : i32) : i32
    %13 = llvm.mlir.constant(100 : index) : i64
    %14 = llvm.mlir.addressof @_QFEa : !llvm.ptr
    %15 = llvm.mlir.addressof @_QFEb : !llvm.ptr
    %16 = llvm.mlir.constant(1 : i64) : i64
    %17 = llvm.mlir.constant(1 : i64) : i64
    %18 = llvm.mlir.constant(1 : i64) : i64
    %19 = llvm.mlir.constant(1 : i64) : i64
    llvm.store %12, %5 : i32, !llvm.ptr
    %20 = llvm.trunc %9 : i64 to i32
    llvm.br ^bb1(%20, %13 : i32, i64)
  ^bb1(%21: i32, %22: i64):  // 2 preds: ^bb0, ^bb2
    %23 = llvm.icmp "sgt" %22, %8 : i64
    llvm.cond_br %23, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    llvm.store %21, %7 : i32, !llvm.ptr
    %24 = llvm.load %7 : !llvm.ptr -> i32
    %25 = llvm.sext %24 : i32 to i64
    %26 = llvm.mlir.constant(1 : i64) : i64
    %27 = llvm.mlir.constant(0 : i64) : i64
    %28 = llvm.sub %25, %26 overflow<nsw> : i64
    %29 = llvm.mul %28, %26 overflow<nsw> : i64
    %30 = llvm.mul %29, %26 overflow<nsw> : i64
    %31 = llvm.add %30, %27 overflow<nsw> : i64
    %32 = llvm.mul %26, %13 overflow<nsw> : i64
    %33 = llvm.getelementptr %14[%31] : (!llvm.ptr, i64) -> !llvm.ptr, i32
    llvm.store %24, %33 : i32, !llvm.ptr
    %34 = llvm.load %7 : !llvm.ptr -> i32
    %35 = llvm.add %34, %20 : i32
    %36 = llvm.sub %22, %9 : i64
    llvm.br ^bb1(%35, %36 : i32, i64)
  ^bb3:  // pred: ^bb1
    llvm.store %21, %7 : i32, !llvm.ptr
    omp.parallel {
      %37 = llvm.mlir.constant(1 : i64) : i64
      %38 = llvm.alloca %37 x i32 {bindc_name = "k", pinned} : (i64) -> !llvm.ptr
      %39 = llvm.mlir.constant(1 : i64) : i64
      omp.wsloop reduction(mod: InScan, @add_reduction_i32 %5 -> %arg0 : !llvm.ptr) {
        omp.loop_nest (%arg1) : i32 = (%11) to (%10) inclusive step (%11) {
          llvm.store %arg1, %38 : i32, !llvm.ptr
          %40 = llvm.load %arg0 : !llvm.ptr -> i32
          %41 = llvm.load %38 : !llvm.ptr -> i32
          %42 = llvm.sext %41 : i32 to i64
          %43 = llvm.mlir.constant(1 : i64) : i64
          %44 = llvm.mlir.constant(0 : i64) : i64
          %45 = llvm.sub %42, %43 overflow<nsw> : i64
          %46 = llvm.mul %45, %43 overflow<nsw> : i64
          %47 = llvm.mul %46, %43 overflow<nsw> : i64
          %48 = llvm.add %47, %44 overflow<nsw> : i64
          %49 = llvm.mul %43, %13 overflow<nsw> : i64
          %50 = llvm.getelementptr %14[%48] : (!llvm.ptr, i64) -> !llvm.ptr, i32
          %51 = llvm.load %50 : !llvm.ptr -> i32
          %52 = llvm.add %40, %51 : i32
          llvm.store %52, %arg0 : i32, !llvm.ptr
          omp.scan inclusive(%5 : !llvm.ptr)
          %53 = llvm.load %arg0 : !llvm.ptr -> i32
          %54 = llvm.load %38 : !llvm.ptr -> i32
          %55 = llvm.sext %54 : i32 to i64
          %56 = llvm.mlir.constant(1 : i64) : i64
          %57 = llvm.mlir.constant(0 : i64) : i64
          %58 = llvm.sub %55, %56 overflow<nsw> : i64
          %59 = llvm.mul %58, %56 overflow<nsw> : i64
          %60 = llvm.mul %59, %56 overflow<nsw> : i64
          %61 = llvm.add %60, %57 overflow<nsw> : i64
          %62 = llvm.mul %56, %13 overflow<nsw> : i64
          %63 = llvm.getelementptr %15[%61] : (!llvm.ptr, i64) -> !llvm.ptr, i32
          llvm.store %53, %63 : i32, !llvm.ptr
          omp.yield
        }
      }
      omp.terminator
    }
    llvm.return
  }
  llvm.mlir.global internal @_QFEa() {addr_space = 0 : i32} : !llvm.array<100 x i32> {
    %0 = llvm.mlir.zero : !llvm.array<100 x i32>
    llvm.return %0 : !llvm.array<100 x i32>
  }
  llvm.mlir.global internal @_QFEb() {addr_space = 0 : i32} : !llvm.array<100 x i32> {
    %0 = llvm.mlir.zero : !llvm.array<100 x i32>
    llvm.return %0 : !llvm.array<100 x i32>
  }
  llvm.mlir.global internal constant @_QFECn() {addr_space = 0 : i32} : i32 {
    %0 = llvm.mlir.constant(100 : i32) : i32
    llvm.return %0 : i32
  }
  llvm.func @_FortranAProgramStart(i32, !llvm.ptr, !llvm.ptr, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @_FortranAProgramEndStatement() attributes {sym_visibility = "private"}
  llvm.func @main(%arg0: i32, %arg1: !llvm.ptr, %arg2: !llvm.ptr) -> i32 {
    %0 = llvm.mlir.constant(0 : i32) : i32
    %1 = llvm.mlir.zero : !llvm.ptr
    llvm.call @_FortranAProgramStart(%arg0, %arg1, %arg2, %1) {fastmathFlags = #llvm.fastmath<contract>} : (i32, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    llvm.call @_QQmain() {fastmathFlags = #llvm.fastmath<contract>} : () -> ()
    llvm.call @_FortranAProgramEndStatement() {fastmathFlags = #llvm.fastmath<contract>} : () -> ()
    llvm.return %0 : i32
  }
}
