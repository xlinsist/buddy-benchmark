	.text
	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_f2p2_d2p2_v1p0_zicsr2p0_zve32f1p0_zve32x1p0_zve64d1p0_zve64f1p0_zve64x1p0_zvl128b1p0_zvl32b1p0_zvl64b1p0"
	.file	"LLVMDialectModule"
	.globl	vector_add_2d                   # -- Begin function vector_add_2d
	.p2align	2
	.type	vector_add_2d,@function
vector_add_2d:                          # @vector_add_2d
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -160
	.cfi_def_cfa_offset 160
	sd	ra, 152(sp)                     # 8-byte Folded Spill
	.cfi_offset ra, -8
	sd	a1, 96(sp)                      # 8-byte Folded Spill
	sd	a0, 104(sp)                     # 8-byte Folded Spill
	mul	a0, a1, a0
	slli	a0, a0, 2
	sd	a0, 120(sp)                     # 8-byte Folded Spill
	call	malloc@plt
	mv	a1, a0
	ld	a0, 120(sp)                     # 8-byte Folded Reload
	sd	a1, 112(sp)                     # 8-byte Folded Spill
	call	malloc@plt
	mv	a1, a0
	ld	a0, 120(sp)                     # 8-byte Folded Reload
	sd	a1, 128(sp)                     # 8-byte Folded Spill
	call	malloc@plt
	sd	a0, 136(sp)                     # 8-byte Folded Spill
	li	a0, 0
	sd	a0, 144(sp)                     # 8-byte Folded Spill
	j	.LBB0_1
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	ld	a1, 104(sp)                     # 8-byte Folded Reload
	ld	a0, 144(sp)                     # 8-byte Folded Reload
	sd	a0, 88(sp)                      # 8-byte Folded Spill
	bge	a0, a1, .LBB0_6
	j	.LBB0_2
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sd	a0, 80(sp)                      # 8-byte Folded Spill
	j	.LBB0_3
.LBB0_3:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	ld	a1, 96(sp)                      # 8-byte Folded Reload
	ld	a0, 80(sp)                      # 8-byte Folded Reload
	sd	a0, 72(sp)                      # 8-byte Folded Spill
	bge	a0, a1, .LBB0_5
	j	.LBB0_4
.LBB0_4:                                #   in Loop: Header=BB0_3 Depth=2
	ld	a0, 72(sp)                      # 8-byte Folded Reload
	ld	a1, 112(sp)                     # 8-byte Folded Reload
	ld	a2, 88(sp)                      # 8-byte Folded Reload
	ld	a3, 96(sp)                      # 8-byte Folded Reload
	mul	a2, a2, a3
	add	a2, a2, a0
	slli	a2, a2, 2
	add	a2, a1, a2
	lui	a1, 260096
	sw	a1, 0(a2)
	addi	a0, a0, 1
	sd	a0, 80(sp)                      # 8-byte Folded Spill
	j	.LBB0_3
.LBB0_5:                                #   in Loop: Header=BB0_1 Depth=1
	ld	a0, 88(sp)                      # 8-byte Folded Reload
	addi	a0, a0, 1
	sd	a0, 144(sp)                     # 8-byte Folded Spill
	j	.LBB0_1
.LBB0_6:
	li	a0, 0
	sd	a0, 64(sp)                      # 8-byte Folded Spill
	j	.LBB0_7
.LBB0_7:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_9 Depth 2
	ld	a1, 104(sp)                     # 8-byte Folded Reload
	ld	a0, 64(sp)                      # 8-byte Folded Reload
	sd	a0, 56(sp)                      # 8-byte Folded Spill
	bge	a0, a1, .LBB0_12
	j	.LBB0_8
.LBB0_8:                                #   in Loop: Header=BB0_7 Depth=1
	li	a0, 0
	sd	a0, 48(sp)                      # 8-byte Folded Spill
	j	.LBB0_9
.LBB0_9:                                #   Parent Loop BB0_7 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	ld	a1, 96(sp)                      # 8-byte Folded Reload
	ld	a0, 48(sp)                      # 8-byte Folded Reload
	sd	a0, 40(sp)                      # 8-byte Folded Spill
	bge	a0, a1, .LBB0_11
	j	.LBB0_10
.LBB0_10:                               #   in Loop: Header=BB0_9 Depth=2
	ld	a0, 40(sp)                      # 8-byte Folded Reload
	ld	a1, 128(sp)                     # 8-byte Folded Reload
	ld	a2, 56(sp)                      # 8-byte Folded Reload
	ld	a3, 96(sp)                      # 8-byte Folded Reload
	mul	a2, a2, a3
	add	a2, a2, a0
	slli	a2, a2, 2
	add	a2, a1, a2
	lui	a1, 262144
	sw	a1, 0(a2)
	addi	a0, a0, 1
	sd	a0, 48(sp)                      # 8-byte Folded Spill
	j	.LBB0_9
.LBB0_11:                               #   in Loop: Header=BB0_7 Depth=1
	ld	a0, 56(sp)                      # 8-byte Folded Reload
	addi	a0, a0, 1
	sd	a0, 64(sp)                      # 8-byte Folded Spill
	j	.LBB0_7
.LBB0_12:
	li	a0, 0
	sd	a0, 32(sp)                      # 8-byte Folded Spill
	j	.LBB0_13
.LBB0_13:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_15 Depth 2
	ld	a1, 104(sp)                     # 8-byte Folded Reload
	ld	a0, 32(sp)                      # 8-byte Folded Reload
	sd	a0, 24(sp)                      # 8-byte Folded Spill
	bge	a0, a1, .LBB0_18
	j	.LBB0_14
.LBB0_14:                               #   in Loop: Header=BB0_13 Depth=1
	li	a0, 0
	sd	a0, 16(sp)                      # 8-byte Folded Spill
	j	.LBB0_15
.LBB0_15:                               #   Parent Loop BB0_13 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	ld	a1, 96(sp)                      # 8-byte Folded Reload
	ld	a0, 16(sp)                      # 8-byte Folded Reload
	sd	a0, 8(sp)                       # 8-byte Folded Spill
	bge	a0, a1, .LBB0_17
	j	.LBB0_16
.LBB0_16:                               #   in Loop: Header=BB0_15 Depth=2
	ld	a0, 8(sp)                       # 8-byte Folded Reload
	ld	a1, 136(sp)                     # 8-byte Folded Reload
	ld	a3, 128(sp)                     # 8-byte Folded Reload
	ld	a4, 112(sp)                     # 8-byte Folded Reload
	ld	a2, 24(sp)                      # 8-byte Folded Reload
	ld	a5, 96(sp)                      # 8-byte Folded Reload
	mul	a2, a2, a5
	add	a2, a2, a0
	slli	a2, a2, 2
	add	a4, a4, a2
	flw	fa5, 0(a4)
	add	a3, a3, a2
	flw	fa4, 0(a3)
	fadd.s	fa5, fa5, fa4
	lui	a3, 260096
	fmv.w.x	fa4, a3
	fadd.s	fa4, fa5, fa4
	lui	a3, 262144
	fmv.w.x	fa3, a3
	fadd.s	fa5, fa5, fa3
	fadd.s	fa5, fa5, fa4
	add	a1, a1, a2
	fsw	fa5, 0(a1)
	addi	a0, a0, 1
	sd	a0, 16(sp)                      # 8-byte Folded Spill
	j	.LBB0_15
.LBB0_17:                               #   in Loop: Header=BB0_13 Depth=1
	ld	a0, 24(sp)                      # 8-byte Folded Reload
	addi	a0, a0, 1
	sd	a0, 32(sp)                      # 8-byte Folded Spill
	j	.LBB0_13
.LBB0_18:
	ld	a1, 136(sp)                     # 8-byte Folded Reload
	ld	a0, 96(sp)                      # 8-byte Folded Reload
	li	a2, 28
	mul	a0, a0, a2
	add	a0, a0, a1
	flw	fa0, 168(a0)
	ld	ra, 152(sp)                     # 8-byte Folded Reload
	addi	sp, sp, 160
	ret
.Lfunc_end0:
	.size	vector_add_2d, .Lfunc_end0-vector_add_2d
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
