	.text
	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_f2p2_d2p2_v1p0_zicsr2p0_zve32f1p0_zve32x1p0_zve64d1p0_zve64f1p0_zve64x1p0_zvl128b1p0_zvl32b1p0_zvl64b1p0"
	.file	"LLVMDialectModule"
	.globl	vectorize_matmul                # -- Begin function vectorize_matmul
	.p2align	2
	.type	vectorize_matmul,@function
vectorize_matmul:                       # @vectorize_matmul
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -160
	.cfi_def_cfa_offset 160
	mv	t0, a6
	mv	a6, a5
	mv	a5, a2
	mv	a2, a1
	mv	a1, a0
	ld	a0, 256(sp)
	ld	a0, 248(sp)
	sd	a0, 80(sp)                      # 8-byte Folded Spill
	ld	a0, 240(sp)
	sd	a0, 88(sp)                      # 8-byte Folded Spill
                                        # kill: def $x6 killed $x10
	ld	t1, 232(sp)
	ld	t1, 224(sp)
	ld	t1, 216(sp)
	sd	t1, 96(sp)                      # 8-byte Folded Spill
	ld	t1, 208(sp)
	ld	t1, 200(sp)
	ld	t1, 192(sp)
	sd	t1, 104(sp)                     # 8-byte Folded Spill
	ld	t1, 184(sp)
	ld	t1, 176(sp)
	ld	t1, 168(sp)
	ld	t1, 160(sp)
	sd	t1, 112(sp)                     # 8-byte Folded Spill
	sd	a6, 120(sp)                     # 8-byte Folded Spill
                                        # kill: def $x16 killed $x14
                                        # kill: def $x16 killed $x13
	sd	a2, 128(sp)                     # 8-byte Folded Spill
	sd	a3, 136(sp)                     # 8-byte Folded Spill
	sd	a4, 144(sp)                     # 8-byte Folded Spill
	li	a0, 0
	sd	a0, 152(sp)                     # 8-byte Folded Spill
	j	.LBB0_1
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	ld	a1, 136(sp)                     # 8-byte Folded Reload
	ld	a0, 152(sp)                     # 8-byte Folded Reload
	sd	a0, 72(sp)                      # 8-byte Folded Spill
	bge	a0, a1, .LBB0_6
	j	.LBB0_2
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sd	a0, 64(sp)                      # 8-byte Folded Spill
	j	.LBB0_3
.LBB0_3:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	ld	a1, 88(sp)                      # 8-byte Folded Reload
	ld	a0, 64(sp)                      # 8-byte Folded Reload
	sd	a0, 56(sp)                      # 8-byte Folded Spill
	bge	a0, a1, .LBB0_5
	j	.LBB0_4
.LBB0_4:                                #   in Loop: Header=BB0_3 Depth=2
	ld	a0, 56(sp)                      # 8-byte Folded Reload
	ld	a1, 96(sp)                      # 8-byte Folded Reload
	ld	a2, 72(sp)                      # 8-byte Folded Reload
	ld	a3, 80(sp)                      # 8-byte Folded Reload
	mul	a2, a2, a3
	add	a2, a2, a0
	slli	a2, a2, 2
	add	a2, a1, a2
	li	a1, 0
	sw	a1, 0(a2)
	addi	a0, a0, 1
	sd	a0, 64(sp)                      # 8-byte Folded Spill
	j	.LBB0_3
.LBB0_5:                                #   in Loop: Header=BB0_1 Depth=1
	ld	a0, 72(sp)                      # 8-byte Folded Reload
	addi	a0, a0, 1
	sd	a0, 152(sp)                     # 8-byte Folded Spill
	j	.LBB0_1
.LBB0_6:
	li	a0, 0
	sd	a0, 48(sp)                      # 8-byte Folded Spill
	j	.LBB0_7
.LBB0_7:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_9 Depth 2
                                        #       Child Loop BB0_11 Depth 3
	ld	a1, 136(sp)                     # 8-byte Folded Reload
	ld	a0, 48(sp)                      # 8-byte Folded Reload
	sd	a0, 40(sp)                      # 8-byte Folded Spill
	bge	a0, a1, .LBB0_15
	j	.LBB0_8
.LBB0_8:                                #   in Loop: Header=BB0_7 Depth=1
	li	a0, 0
	sd	a0, 32(sp)                      # 8-byte Folded Spill
	j	.LBB0_9
.LBB0_9:                                #   Parent Loop BB0_7 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_11 Depth 3
	ld	a1, 88(sp)                      # 8-byte Folded Reload
	ld	a0, 32(sp)                      # 8-byte Folded Reload
	sd	a0, 24(sp)                      # 8-byte Folded Spill
	bge	a0, a1, .LBB0_14
	j	.LBB0_10
.LBB0_10:                               #   in Loop: Header=BB0_9 Depth=2
	li	a0, 0
	sd	a0, 16(sp)                      # 8-byte Folded Spill
	j	.LBB0_11
.LBB0_11:                               #   Parent Loop BB0_7 Depth=1
                                        #     Parent Loop BB0_9 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	ld	a1, 144(sp)                     # 8-byte Folded Reload
	ld	a0, 16(sp)                      # 8-byte Folded Reload
	sd	a0, 8(sp)                       # 8-byte Folded Spill
	bge	a0, a1, .LBB0_13
	j	.LBB0_12
.LBB0_12:                               #   in Loop: Header=BB0_11 Depth=3
	ld	a0, 8(sp)                       # 8-byte Folded Reload
	ld	a1, 96(sp)                      # 8-byte Folded Reload
	ld	a3, 24(sp)                      # 8-byte Folded Reload
	ld	a2, 40(sp)                      # 8-byte Folded Reload
	ld	a4, 80(sp)                      # 8-byte Folded Reload
	ld	a5, 128(sp)                     # 8-byte Folded Reload
	ld	a6, 120(sp)                     # 8-byte Folded Reload
	ld	a7, 112(sp)                     # 8-byte Folded Reload
	ld	t0, 104(sp)                     # 8-byte Folded Reload
	mul	t0, a0, t0
	add	t0, t0, a3
	slli	t0, t0, 2
	add	a7, a7, t0
	flw	fa4, 0(a7)
	mul	a6, a2, a6
	add	a6, a6, a0
	slli	a6, a6, 2
	add	a5, a5, a6
	flw	fa5, 0(a5)
	fmul.s	fa4, fa5, fa4
	mul	a2, a2, a4
	add	a2, a2, a3
	slli	a2, a2, 2
	add	a1, a1, a2
	flw	fa5, 0(a1)
	fadd.s	fa5, fa5, fa4
	fsw	fa5, 0(a1)
	addi	a0, a0, 1
	sd	a0, 16(sp)                      # 8-byte Folded Spill
	j	.LBB0_11
.LBB0_13:                               #   in Loop: Header=BB0_9 Depth=2
	ld	a0, 24(sp)                      # 8-byte Folded Reload
	addi	a0, a0, 1
	sd	a0, 32(sp)                      # 8-byte Folded Spill
	j	.LBB0_9
.LBB0_14:                               #   in Loop: Header=BB0_7 Depth=1
	ld	a0, 40(sp)                      # 8-byte Folded Reload
	addi	a0, a0, 1
	sd	a0, 48(sp)                      # 8-byte Folded Spill
	j	.LBB0_7
.LBB0_15:
	addi	sp, sp, 160
	ret
.Lfunc_end0:
	.size	vectorize_matmul, .Lfunc_end0-vectorize_matmul
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
