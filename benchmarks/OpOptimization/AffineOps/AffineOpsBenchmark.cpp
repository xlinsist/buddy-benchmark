//===- MatMulBenchmark.cpp ------------------------------------------------===//

#include <benchmark/benchmark.h>
#include <buddy/Core/Container.h>
#include <iostream>
#include <random>

namespace {
extern "C" {

float _mlir_ciface_add2d(int M, int N);
float _mlir_ciface_add2d_vector_8(int M, int N);
float _mlir_ciface_add2d_vector_16(int M, int N);
float _mlir_ciface_add2d_vector_32(int M, int N);
float _mlir_ciface_add2d_vector_64(int M, int N);
float _mlir_ciface_add2d_vector_128(int M, int N);

void _mlir_ciface_reduction(MemRef<float, 2> *A, MemRef<float, 1> *B);
void _mlir_ciface_reduction_vector_8(MemRef<float, 2> *A, MemRef<float, 1> *B);
void _mlir_ciface_reduction_vector_16(MemRef<float, 2> *A, MemRef<float, 1> *B);
void _mlir_ciface_reduction_vector_32(MemRef<float, 2> *A, MemRef<float, 1> *B);
void _mlir_ciface_reduction_vector_64(MemRef<float, 2> *A, MemRef<float, 1> *B);
void _mlir_ciface_reduction_vector_128(MemRef<float, 2> *A,
                                       MemRef<float, 1> *B);

void _mlir_ciface_transpose(MemRef<float, 3> *A, MemRef<float, 3> *B);
void _mlir_ciface_transpose_vector_8(MemRef<float, 3> *A, MemRef<float, 3> *B);
void _mlir_ciface_transpose_vector_16(MemRef<float, 3> *A, MemRef<float, 3> *B);
void _mlir_ciface_transpose_vector_32(MemRef<float, 3> *A, MemRef<float, 3> *B);
void _mlir_ciface_transpose_vector_64(MemRef<float, 3> *A, MemRef<float, 3> *B);
void _mlir_ciface_transpose_vector_128(MemRef<float, 3> *A,
                                       MemRef<float, 3> *B);

void _mlir_ciface_matmul(MemRef<float, 2> *A, MemRef<float, 2> *B,
                         MemRef<float, 2> *C);
void _mlir_ciface_matmul_vector_8(MemRef<float, 2> *A, MemRef<float, 2> *B,
                                  MemRef<float, 2> *C);
void _mlir_ciface_matmul_vector_16(MemRef<float, 2> *A, MemRef<float, 2> *B,
                                   MemRef<float, 2> *C);
void _mlir_ciface_matmul_vector_32(MemRef<float, 2> *A, MemRef<float, 2> *B,
                                   MemRef<float, 2> *C);
void _mlir_ciface_matmul_vector_64(MemRef<float, 2> *A, MemRef<float, 2> *B,
                                   MemRef<float, 2> *C);
void _mlir_ciface_matmul_vector_128(MemRef<float, 2> *A, MemRef<float, 2> *B,
                                    MemRef<float, 2> *C);
}

#define DefineAdd2DBenchmark(name, func)                                       \
  void name(benchmark::State &state) {                                         \
    int M = 100000, N = 128;                                                   \
    float ans;                                                                 \
    for (auto _ : state) {                                                     \
      func(M, N);                                                              \
    }                                                                          \
  }

#define DefineReductionBenchmark(name, func)                                   \
  void name(benchmark::State &state) {                                         \
    int M = 100000, N = 128;                                                   \
    intptr_t sizesA[2] = {M, N};                                               \
    intptr_t sizesB[1] = {M};                                                  \
    MemRef<float, 2> A(sizesA, 1.0);                                           \
    MemRef<float, 1> B(sizesB, 0.0);                                           \
    for (auto _ : state) {                                                     \
      func(&A, &B);                                                            \
    }                                                                          \
  }

#define DefineTransposeBenchmark(name, func)                                   \
  void name(benchmark::State &state) {                                         \
    int M = 128, N = 128, K = 128;                                             \
    intptr_t sizesA[3] = {M, N, K};                                            \
    intptr_t sizesB[3] = {K, M, N};                                            \
    MemRef<float, 3> A(sizesA, 1.0);                                           \
    MemRef<float, 3> B(sizesB, 0.0);                                           \
    for (auto _ : state) {                                                     \
      func(&A, &B);                                                            \
    }                                                                          \
  }

#define DefineMatmulBenchmark(name, func)                                      \
  void name(benchmark::State &state) {                                         \
    int M = 128, N = 128, K = 128;                                             \
    intptr_t sizesA[2] = {M, K};                                               \
    intptr_t sizesB[2] = {K, N};                                               \
    intptr_t sizesC[2] = {M, N};                                               \
    MemRef<float, 2> A(sizesA, 1.0);                                           \
    MemRef<float, 2> B(sizesB, 1.0);                                           \
    MemRef<float, 2> C(sizesC, 0.0);                                           \
    for (auto _ : state) {                                                     \
      func(&A, &B, &C);                                                        \
    }                                                                          \
  }

#define RUN_BENCHMARK(name, func)                                              \
  Define##name##Benchmark(name, func) BENCHMARK(name)->Unit(                   \
      benchmark::kMillisecond);                                                \
  Define##name##Benchmark(name##Vector8, func##_vector_8)                      \
      BENCHMARK(name##Vector8)                                                 \
          ->Unit(benchmark::kMillisecond);                                     \
  Define##name##Benchmark(name##Vector16, func##_vector_16)                    \
      BENCHMARK(name##Vector16)                                                \
          ->Unit(benchmark::kMillisecond);                                     \
  Define##name##Benchmark(name##Vector32, func##_vector_32)                    \
      BENCHMARK(name##Vector32)                                                \
          ->Unit(benchmark::kMillisecond);                                     \
  Define##name##Benchmark(name##Vector64, func##_vector_64)                    \
      BENCHMARK(name##Vector64)                                                \
          ->Unit(benchmark::kMillisecond);                                     \
  Define##name##Benchmark(name##Vector128, func##_vector_128)                  \
      BENCHMARK(name##Vector128)                                               \
          ->Unit(benchmark::kMillisecond);

RUN_BENCHMARK(Add2D, _mlir_ciface_add2d)
RUN_BENCHMARK(Reduction, _mlir_ciface_reduction)
RUN_BENCHMARK(Transpose, _mlir_ciface_transpose)
RUN_BENCHMARK(Matmul, _mlir_ciface_matmul)

} // namespace
