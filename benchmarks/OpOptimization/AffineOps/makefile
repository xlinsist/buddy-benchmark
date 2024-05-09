#!/bin/bash
BUDDY_OPT := /root/intern/buddy-mlir/build/bin/buddy-opt
MLIR_OPT := /root/intern/buddy-mlir/llvm/build/bin/mlir-opt
MLIR_TRANSLATE := /root/intern/buddy-mlir/llvm/build/bin/mlir-translate
MLIR_CPU_RUNNER := /root/intern/buddy-mlir/llvm/build/bin/mlir-cpu-runner
LLC := /root/intern/buddy-mlir/llvm/build/bin/llc
OPT_FLAG := -O0

test-lower:
	@${MLIR_OPT} Add2D.mlir \
		-affine-super-vectorize="virtual-vector-size=128" \
		-convert-vector-to-scf -lower-affine -convert-scf-to-cf \
		-convert-vector-to-llvm -finalize-memref-to-llvm -convert-func-to-llvm \
		-reconcile-unrealized-casts

test-asm:
	@${MLIR_OPT} Add2D.mlir \
		-affine-super-vectorize="virtual-vector-size=32" \
		-convert-vector-to-scf -lower-affine -convert-scf-to-cf \
		-convert-vector-to-llvm -finalize-memref-to-llvm -convert-func-to-llvm \
		-reconcile-unrealized-casts | \
	${MLIR_TRANSLATE} --mlir-to-llvmir | \
	${LLC} ${OPT_FLAG} -mtriple riscv64 -target-abi lp64d \
		-mattr=+m,+d,+v -riscv-v-vector-bits-min=128 \
		--filetype=asm -o log.s

test1-asm:
	@${MLIR_OPT} VectorizeMatmul.mlir \
		-lower-affine \
		-convert-vector-to-scf -lower-affine -convert-scf-to-cf \
		-convert-vector-to-llvm -finalize-memref-to-llvm -convert-func-to-llvm \
		-reconcile-unrealized-casts | \
	${MLIR_TRANSLATE} --mlir-to-llvmir | \
	${LLC} ${OPT_FLAG} -mtriple riscv64 -target-abi lp64d \
		-mattr=+m,+d,+v -riscv-v-vector-bits-min=128 \
		--filetype=asm -o log1.s



