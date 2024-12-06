//===- OpenMPToLLVMIRTranslation.h - OpenMP Dialect to LLVM IR --*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This provides registration calls for OpenMP dialect to LLVM IR translation.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_TARGET_LLVMIR_DIALECT_OPENMP_OPENMPTOLLVMIRTRANSLATION_H
#define MLIR_TARGET_LLVMIR_DIALECT_OPENMP_OPENMPTOLLVMIRTRANSLATION_H

#include "llvm/IR/IRBuilder.h"
#include "mlir/Dialect/OpenMP/OpenMPDialect.h"
namespace mlir {

class DialectRegistry;
class MLIRContext;

class OMPCodeGen{
    public:
      llvm::BasicBlock *OMPBeforeScanBlock = nullptr;
      llvm::BasicBlock *OMPAfterScanBlock = nullptr;
      llvm::BasicBlock *OMPScanExitBlock = nullptr;
      llvm::BasicBlock *OMPScanDispatch = nullptr;
      bool OMPFirstScanLoop = false; 
      llvm::SmallDenseMap<omp::DeclareReductionOp, llvm::Value *> ScanBuffs;      
      SmallVector<llvm::Value *> privateReductionVariables;
      llvm::Value *iv;
      SmallVector<llvm::BasicBlock *> continueBlocks;


  class ParentLoopDirectiveForScanRegion {
    const omp::WsloopOp ParentLoopDirectiveForScan;

  public:
    ParentLoopDirectiveForScanRegion(
        const omp::WsloopOp &ParentLoopDirectiveForScan)
        : ParentLoopDirectiveForScan(ParentLoopDirectiveForScan) {
      //CGF.OMPParentLoopDirectiveForScan = &ParentLoopDirectiveForScan;
    }
    //~ParentLoopDirectiveForScanRegion() {
    //  CGF.OMPParentLoopDirectiveForScan = ParentLoopDirectiveForScan;
    //}
  };
};

/// Register the OpenMP dialect and the translation from it to the LLVM IR in
/// the given registry;
void registerOpenMPDialectTranslation(DialectRegistry &registry);

/// Register the OpenMP dialect and the translation from it in the registry
/// associated with the given context.
void registerOpenMPDialectTranslation(MLIRContext &context);

} // namespace mlir

#endif // MLIR_TARGET_LLVMIR_DIALECT_OPENMP_OPENMPTOLLVMIRTRANSLATION_H
