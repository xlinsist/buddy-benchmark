function(add_e2e_custom_command output_file mlir_file mlir_opt_flags mlir_translate_flags)
  if(CMAKE_TOOLCHAIN_FILE STREQUAL ${BUDDY_SOURCE_DIR}/cmake/riscv-toolchain.cmake)
    # Generate RISC-V object file.
    set(target_triple "riscv64")
    set(target_attr "+m,+d,+v")
    set(target_attr_additional "--target-abi=lp64d" "--relocation-model=pic" "-riscv-v-vector-bits-min=128")
  else()
    # Generate x86 object file.
    set(target_triple "${BUDDY_OPT_TRIPLE}")
    set(target_attr "${BUDDY_OPT_ATTR}")
  endif()

  set(mlir_opt_commands "${LLVM_MLIR_BINARY_DIR}/mlir-opt")
  foreach(flag IN LISTS mlir_opt_flags)
    list(APPEND mlir_opt_commands "${flag}")
  endforeach()

  add_custom_command(OUTPUT ${output_file}
    COMMAND cat ${BUDDY_SOURCE_DIR}/benchmarks/OpOptimization/MatMul/${mlir_file} |
            ${mlir_opt_commands} |
            ${LLVM_MLIR_BINARY_DIR}/mlir-translate ${mlir_translate_flags} |
            ${LLVM_MLIR_BINARY_DIR}/llc -O3 -mtriple=${target_triple} -mattr=${target_attr}
              ${target_attr_additional} --filetype=obj
              -o ${BUDDY_BINARY_DIR}/../benchmarks/OpOptimization/MatMul/${output_file}
  )
endfunction()

# BM_MATMUL_SCALAR
add_e2e_custom_command(
  "matmul-scalar.o" 
  "MatMul.mlir" 
  "-convert-linalg-to-loops;-lower-affine;-convert-scf-to-cf;-convert-vector-to-llvm;-finalize-memref-to-llvm;-convert-arith-to-llvm;-llvm-request-c-wrappers;-convert-func-to-llvm;-reconcile-unrealized-casts"
  "--mlir-to-llvmir"
)

# BM_MATMUL_OCV
add_e2e_custom_command(
  "matmul-ocv.o" 
  "MatMulOCV.mlir" 
  "-expand-strided-metadata;-lower-affine;-convert-vector-to-llvm;-finalize-memref-to-llvm;-convert-scf-to-cf;-llvm-request-c-wrappers;-convert-func-to-llvm;-reconcile-unrealized-casts"
  "--mlir-to-llvmir"
)

# BM_MATMUL_TRANSFORM
add_e2e_custom_command(
  "matmul-transform.o" 
  "MatMulTransform.mlir" 
  "--llvm-request-c-wrappers;--test-lower-to-llvm"
  "--mlir-to-llvmir"
)

# BM_MATMUL_BROADCAST
add_e2e_custom_command(
  "matmul-broadcast-32.o" 
  "MatMulBroadcast.mlir" 
  "-convert-linalg-to-loops;-lower-affine;-convert-scf-to-cf;-convert-vector-to-llvm;-finalize-memref-to-llvm;-convert-arith-to-llvm;-llvm-request-c-wrappers;-convert-func-to-llvm;-reconcile-unrealized-casts"
  "--mlir-to-llvmir"
)

add_library(MatMulScalar STATIC "matmul-scalar.o")
add_library(MatMulOCV STATIC "matmul-ocv.o")
add_library(MatMulTransform STATIC "matmul-transform.o")
add_library(MatMulBroadcast32 STATIC "matmul-broadcast-32.o")
set_target_properties(MatMulScalar MatMulOCV MatMulTransform MatMulBroadcast32 PROPERTIES LINKER_LANGUAGE CXX)

add_executable(matmul-benchmark Main.cpp MatMulBenchmark.cpp)
target_link_libraries(matmul-benchmark GoogleBenchmark MatMulScalar MatMulOCV MatMulTransform MatMulBroadcast32)
