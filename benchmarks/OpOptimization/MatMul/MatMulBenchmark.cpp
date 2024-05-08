//===- MatMulBenchmark.cpp ------------------------------------------------===//

#include <benchmark/benchmark.h>
#include <buddy/Core/Container.h>
#include <iostream>
#include <random>

// Define target layout.
#define M 64
#define N 3136
#define K 576

// Helper functions and variables.
namespace {
const std::string PASS = "\033[32mPASS\033[0m";
const std::string FAIL = "\033[31mFAIL\033[0m";

bool areArraysEqual(float array1[], float array2[], int size) {
  for (int i = 0; i < size; ++i) {
    if (array1[i] != array2[i]) {
      return false;
    }
  }
  return true;
}

// Declare the matmul C interface.
extern "C" {
void _mlir_ciface_matmul_scalar(MemRef<float, 2> *A, MemRef<float, 2> *B,
                                MemRef<float, 2> *C);
void _mlir_ciface_matmul_ocv(MemRef<float, 2> *A, MemRef<float, 2> *B,
                             MemRef<float, 2> *C);
void _mlir_ciface_matmul_transform(MemRef<float, 2> *A, MemRef<float, 2> *B,
                                   MemRef<float, 2> *C);
void _mlir_ciface_matmul_broadcast_32(MemRef<float, 2> *A, MemRef<float, 2> *B,
                                      MemRef<float, 2> *C);
}

#define DEFINE_MATMUL_BENCHMARK(name, func)                                    \
  void BM_MATMUL_##name(benchmark::State &state) {                             \
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

DEFINE_MATMUL_BENCHMARK(SCALAR, _mlir_ciface_matmul_scalar)
DEFINE_MATMUL_BENCHMARK(OCV, _mlir_ciface_matmul_ocv)
DEFINE_MATMUL_BENCHMARK(TRANSFORM, _mlir_ciface_matmul_transform)
DEFINE_MATMUL_BENCHMARK(BROADCAST_32, _mlir_ciface_matmul_broadcast_32)
} // namespace

// Register benchmark cases.
BENCHMARK(BM_MATMUL_SCALAR)->Unit(benchmark::kMillisecond);
BENCHMARK(BM_MATMUL_OCV)->Unit(benchmark::kMillisecond);
BENCHMARK(BM_MATMUL_TRANSFORM)->Unit(benchmark::kMillisecond);
BENCHMARK(BM_MATMUL_BROADCAST_32)->Unit(benchmark::kMillisecond);

void verification() {
  std::random_device rd;
  std::mt19937 generator(rd());
  std::uniform_int_distribution<int> distribution(1, 100);

  intptr_t sizesA[2] = {M, K}, sizesB[2] = {K, N}, sizesC[2] = {M, N};
  const int inputASize = M * K, inputBSize = K * N, outputSize = M * N;
  float inputARand[inputASize], inputBRand[inputBSize];

  for (int i = 0; i < inputASize; ++i)
    inputARand[i] = distribution(generator);
  for (int i = 0; i < inputBSize; ++i)
    inputBRand[i] = distribution(generator);

  MemRef<float, 2> inputAMemRef(inputARand, sizesA);
  MemRef<float, 2> inputBMemRef(inputBRand, sizesB);
  MemRef<float, 2> outputScalar(sizesC, 0), outputOCV(sizesC, 0),
      outputTransform(sizesC, 0), outputBroadcast32(sizesC, 0);

  _mlir_ciface_matmul_scalar(&inputAMemRef, &inputBMemRef, &outputScalar);
  _mlir_ciface_matmul_ocv(&inputAMemRef, &inputBMemRef, &outputOCV);
  _mlir_ciface_matmul_transform(&inputAMemRef, &inputBMemRef, &outputTransform);
  _mlir_ciface_matmul_broadcast_32(&inputAMemRef, &inputBMemRef,
                                   &outputBroadcast32);

  std::cout << "-----------------------------------------------------------\n"
            << "Correctness Verification:\n"
            << "OCV case: "
            << (areArraysEqual(outputScalar.getData(), outputOCV.getData(),
                               outputSize)
                    ? PASS
                    : FAIL)
            << "\n"
            << "Transform case: "
            << (areArraysEqual(outputScalar.getData(),
                               outputTransform.getData(), outputSize)
                    ? PASS
                    : FAIL)
            << "\n"
            << "Broadcast 32 case: "
            << (areArraysEqual(outputScalar.getData(),
                               outputBroadcast32.getData(), outputSize)
                    ? PASS
                    : FAIL)
            << "\n"
            << "-----------------------------------------------------------\n";
}
