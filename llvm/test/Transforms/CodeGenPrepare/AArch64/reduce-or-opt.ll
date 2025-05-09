; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 5
; RUN: opt -codegenprepare -S < %s -mtriple=aarch64-none-linux-gnu -mattr=+sve | FileCheck %s

define i64 @select_or_reduce_v2i1(ptr nocapture noundef readonly %src) {
; CHECK-LABEL: define i64 @select_or_reduce_v2i1(
; CHECK-SAME: ptr noundef readonly captures(none) [[SRC:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  [[ENTRY:.*]]:
; CHECK-NEXT:    br label %[[VECTOR_BODY:.*]]
; CHECK:       [[VECTOR_BODY]]:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %[[ENTRY]] ], [ [[INDEX_NEXT:%.*]], %[[VECTOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds ptr, ptr [[SRC]], i64 [[INDEX]]
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x ptr>, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[COND:%.*]] = icmp eq <2 x ptr> [[WIDE_LOAD]], zeroinitializer
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[OR_REDUC:%.*]] = tail call i1 @llvm.vector.reduce.or.v2i1(<2 x i1> [[COND]])
; CHECK-NEXT:    [[IV_CMP:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    [[EXIT_COND:%.*]] = or i1 [[OR_REDUC]], [[IV_CMP]]
; CHECK-NEXT:    br i1 [[EXIT_COND]], label %[[MIDDLE_SPLIT:.*]], label %[[VECTOR_BODY]]
; CHECK:       [[MIDDLE_SPLIT]]:
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[OR_REDUC]], i64 1, i64 0
; CHECK-NEXT:    ret i64 [[SEL]]
;
entry:
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %arrayidx = getelementptr inbounds ptr, ptr %src, i64 %index
  %wide.load = load <2 x ptr>, ptr %arrayidx, align 8
  %cond = icmp eq <2 x ptr> %wide.load, splat(ptr zeroinitializer)
  %index.next = add nuw i64 %index, 2
  %or.reduc = tail call i1 @llvm.vector.reduce.or.v2i1(<2 x i1> %cond)
  %iv.cmp = icmp eq i64 %index.next, 4
  %exit.cond = or i1 %or.reduc, %iv.cmp
  br i1 %exit.cond, label %middle.split, label %vector.body

middle.split:
  %sel = select i1 %or.reduc, i64 1, i64 0
  ret i64 %sel
}

define i64 @br_or_reduce_v2i1(ptr nocapture noundef readonly %src, ptr noundef readnone %p) {
; CHECK-LABEL: define i64 @br_or_reduce_v2i1(
; CHECK-SAME: ptr noundef readonly captures(none) [[SRC:%.*]], ptr noundef readnone [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  [[ENTRY:.*]]:
; CHECK-NEXT:    br label %[[VECTOR_BODY:.*]]
; CHECK:       [[VECTOR_BODY]]:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %[[ENTRY]] ], [ [[INDEX_NEXT:%.*]], %[[VECTOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds ptr, ptr [[SRC]], i64 [[INDEX]]
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x ptr>, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[COND:%.*]] = icmp eq <2 x ptr> [[WIDE_LOAD]], zeroinitializer
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[OR_REDUC:%.*]] = tail call i1 @llvm.vector.reduce.or.v2i1(<2 x i1> [[COND]])
; CHECK-NEXT:    [[IV_CMP:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    [[EXIT_COND:%.*]] = or i1 [[OR_REDUC]], [[IV_CMP]]
; CHECK-NEXT:    br i1 [[EXIT_COND]], label %[[MIDDLE_SPLIT:.*]], label %[[VECTOR_BODY]]
; CHECK:       [[MIDDLE_SPLIT]]:
; CHECK-NEXT:    br i1 [[OR_REDUC]], label %[[FOUND:.*]], label %[[NOTFOUND:.*]]
; CHECK:       [[FOUND]]:
; CHECK-NEXT:    store i64 56, ptr [[P]], align 8
; CHECK-NEXT:    ret i64 1
; CHECK:       [[NOTFOUND]]:
; CHECK-NEXT:    ret i64 0
;
entry:
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %arrayidx = getelementptr inbounds ptr, ptr %src, i64 %index
  %wide.load = load <2 x ptr>, ptr %arrayidx, align 8
  %cond = icmp eq <2 x ptr> %wide.load, splat(ptr zeroinitializer)
  %index.next = add nuw i64 %index, 2
  %or.reduc = tail call i1 @llvm.vector.reduce.or.v2i1(<2 x i1> %cond)
  %iv.cmp = icmp eq i64 %index.next, 4
  %exit.cond = or i1 %or.reduc, %iv.cmp
  br i1 %exit.cond, label %middle.split, label %vector.body

middle.split:
  br i1 %or.reduc, label %found, label %notfound

found:
  store i64 56, ptr %p, align 8
  ret i64 1

notfound:
  ret i64 0
}

define i64 @select_or_reduce_nxv2i1(ptr nocapture noundef readonly %src) {
; CHECK-LABEL: define i64 @select_or_reduce_nxv2i1(
; CHECK-SAME: ptr noundef readonly captures(none) [[SRC:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  [[ENTRY:.*]]:
; CHECK-NEXT:    br label %[[VECTOR_BODY:.*]]
; CHECK:       [[VECTOR_BODY]]:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %[[ENTRY]] ], [ [[INDEX_NEXT:%.*]], %[[VECTOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds ptr, ptr [[SRC]], i64 [[INDEX]]
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 2 x ptr>, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[COND:%.*]] = icmp eq <vscale x 2 x ptr> [[WIDE_LOAD]], zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = shl nuw nsw i64 [[TMP0]], 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP1]]
; CHECK-NEXT:    [[OR_REDUC:%.*]] = tail call i1 @llvm.vector.reduce.or.nxv2i1(<vscale x 2 x i1> [[COND]])
; CHECK-NEXT:    [[IV_CMP:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    [[EXIT_COND:%.*]] = or i1 [[OR_REDUC]], [[IV_CMP]]
; CHECK-NEXT:    br i1 [[EXIT_COND]], label %[[MIDDLE_SPLIT:.*]], label %[[VECTOR_BODY]]
; CHECK:       [[MIDDLE_SPLIT]]:
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <vscale x 2 x ptr> [[WIDE_LOAD]], zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = tail call i1 @llvm.vector.reduce.or.nxv2i1(<vscale x 2 x i1> [[TMP2]])
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[TMP3]], i64 1, i64 0
; CHECK-NEXT:    ret i64 [[SEL]]
;
entry:
  %vscale = tail call i64 @llvm.vscale.i64()
  %vf = shl nuw nsw i64 %vscale, 1
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %arrayidx = getelementptr inbounds ptr, ptr %src, i64 %index
  %wide.load = load <vscale x 2 x ptr>, ptr %arrayidx, align 8
  %cond = icmp eq <vscale x 2 x ptr> %wide.load, splat(ptr zeroinitializer)
  %index.next = add nuw i64 %index, %vf
  %or.reduc = tail call i1 @llvm.vector.reduce.or.nxv2i1(<vscale x 2 x i1> %cond)
  %iv.cmp = icmp eq i64 %index.next, 4
  %exit.cond = or i1 %or.reduc, %iv.cmp
  br i1 %exit.cond, label %middle.split, label %vector.body

middle.split:
  %sel = select i1 %or.reduc, i64 1, i64 0
  ret i64 %sel
}

define i64 @br_or_reduce_nxv2i1(ptr nocapture noundef readonly %src, ptr noundef readnone %p) {
; CHECK-LABEL: define i64 @br_or_reduce_nxv2i1(
; CHECK-SAME: ptr noundef readonly captures(none) [[SRC:%.*]], ptr noundef readnone [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  [[ENTRY:.*]]:
; CHECK-NEXT:    br label %[[VECTOR_BODY:.*]]
; CHECK:       [[VECTOR_BODY]]:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %[[ENTRY]] ], [ [[INDEX_NEXT:%.*]], %[[VECTOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds ptr, ptr [[SRC]], i64 [[INDEX]]
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 2 x ptr>, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[COND:%.*]] = icmp eq <vscale x 2 x ptr> [[WIDE_LOAD]], zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = shl nuw nsw i64 [[TMP0]], 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP1]]
; CHECK-NEXT:    [[OR_REDUC:%.*]] = tail call i1 @llvm.vector.reduce.or.nxv2i1(<vscale x 2 x i1> [[COND]])
; CHECK-NEXT:    [[IV_CMP:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    [[EXIT_COND:%.*]] = or i1 [[OR_REDUC]], [[IV_CMP]]
; CHECK-NEXT:    br i1 [[EXIT_COND]], label %[[MIDDLE_SPLIT:.*]], label %[[VECTOR_BODY]]
; CHECK:       [[MIDDLE_SPLIT]]:
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <vscale x 2 x ptr> [[WIDE_LOAD]], zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = tail call i1 @llvm.vector.reduce.or.nxv2i1(<vscale x 2 x i1> [[TMP2]])
; CHECK-NEXT:    br i1 [[TMP3]], label %[[FOUND:.*]], label %[[NOTFOUND:.*]]
; CHECK:       [[FOUND]]:
; CHECK-NEXT:    store i64 56, ptr [[P]], align 8
; CHECK-NEXT:    ret i64 1
; CHECK:       [[NOTFOUND]]:
; CHECK-NEXT:    ret i64 0
;
entry:
  %vscale = tail call i64 @llvm.vscale.i64()
  %vf = shl nuw nsw i64 %vscale, 1
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %arrayidx = getelementptr inbounds ptr, ptr %src, i64 %index
  %wide.load = load <vscale x 2 x ptr>, ptr %arrayidx, align 8
  %cond = icmp eq <vscale x 2 x ptr> %wide.load, splat(ptr zeroinitializer)
  %index.next = add nuw i64 %index, %vf
  %or.reduc = tail call i1 @llvm.vector.reduce.or.nxv2i1(<vscale x 2 x i1> %cond)
  %iv.cmp = icmp eq i64 %index.next, 4
  %exit.cond = or i1 %or.reduc, %iv.cmp
  br i1 %exit.cond, label %middle.split, label %vector.body

middle.split:
  br i1 %or.reduc, label %found, label %notfound

found:
  store i64 56, ptr %p, align 8
  ret i64 1

notfound:
  ret i64 0
}

declare i1 @llvm.vector.reduce.or.v2i1(<2 x i1>)
declare i1 @llvm.vector.reduce.or.nxv2i1(<vscale x 2 x i1>)
