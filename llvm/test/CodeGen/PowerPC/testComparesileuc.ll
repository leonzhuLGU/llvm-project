; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,LE

@glob = local_unnamed_addr global i8 0, align 1

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_ileuc(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_ileuc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r4, r3
; CHECK-NEXT:    not r3, r3
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i8 %a, %b
  %conv2 = zext i1 %cmp to i32
  ret i32 %conv2
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_ileuc_sext(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_ileuc_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r4, r3
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    addi r3, r3, -1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_ileuc_z(i8 zeroext %a) {
; CHECK-LABEL: test_ileuc_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    blr
entry:
  %cmp = icmp eq i8 %a, 0
  %conv1 = zext i1 %cmp to i32
  ret i32 %conv1
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_ileuc_sext_z(i8 zeroext %a) {
; CHECK-LABEL: test_ileuc_sext_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i8 %a, 0
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind
define void @test_ileuc_store(i8 zeroext %a, i8 zeroext %b) {
; BE-LABEL: test_ileuc_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    sub r3, r4, r3
; BE-NEXT:    ld r4, .LC0@toc@l(r5)
; BE-NEXT:    not r3, r3
; BE-NEXT:    rldicl r3, r3, 1, 63
; BE-NEXT:    stb r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_ileuc_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sub r3, r4, r3
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    not r3, r3
; LE-NEXT:    rldicl r3, r3, 1, 63
; LE-NEXT:    stb r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp ule i8 %a, %b
  %conv3 = zext i1 %cmp to i8
  store i8 %conv3, i8* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_ileuc_sext_store(i8 zeroext %a, i8 zeroext %b) {
; BE-LABEL: test_ileuc_sext_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    sub r3, r4, r3
; BE-NEXT:    ld r4, .LC0@toc@l(r5)
; BE-NEXT:    rldicl r3, r3, 1, 63
; BE-NEXT:    addi r3, r3, -1
; BE-NEXT:    stb r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_ileuc_sext_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sub r3, r4, r3
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    rldicl r3, r3, 1, 63
; LE-NEXT:    addi r3, r3, -1
; LE-NEXT:    stb r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp ule i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_ileuc_z_store(i8 zeroext %a) {
; BE-LABEL: test_ileuc_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r4, r2, .LC0@toc@ha
; BE-NEXT:    cntlzw r3, r3
; BE-NEXT:    ld r4, .LC0@toc@l(r4)
; BE-NEXT:    srwi r3, r3, 5
; BE-NEXT:    stb r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_ileuc_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    cntlzw r3, r3
; LE-NEXT:    addis r4, r2, glob@toc@ha
; LE-NEXT:    srwi r3, r3, 5
; LE-NEXT:    stb r3, glob@toc@l(r4)
; LE-NEXT:    blr
entry:
  %cmp = icmp eq i8 %a, 0
  %conv2 = zext i1 %cmp to i8
  store i8 %conv2, i8* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_ileuc_sext_z_store(i8 zeroext %a) {
; BE-LABEL: test_ileuc_sext_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r4, r2, .LC0@toc@ha
; BE-NEXT:    cntlzw r3, r3
; BE-NEXT:    ld r4, .LC0@toc@l(r4)
; BE-NEXT:    srwi r3, r3, 5
; BE-NEXT:    neg r3, r3
; BE-NEXT:    stb r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_ileuc_sext_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    cntlzw r3, r3
; LE-NEXT:    addis r4, r2, glob@toc@ha
; LE-NEXT:    srwi r3, r3, 5
; LE-NEXT:    neg r3, r3
; LE-NEXT:    stb r3, glob@toc@l(r4)
; LE-NEXT:    blr
entry:
  %cmp = icmp eq i8 %a, 0
  %conv2 = sext i1 %cmp to i8
  store i8 %conv2, i8* @glob
  ret void
}

