//===- MLIRGccLoopsEx1Benchmark.cpp --------------------------------------------===//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//===----------------------------------------------------------------------===//
//
// This file implements the benchmark for buddy-opt tool in buddy-mlir project.
//
//===----------------------------------------------------------------------===//

#include <benchmark/benchmark.h>
#include <buddy/Core/Container.h>
#include <iostream>

// Declare the gccloopsex1 C interface.
extern "C" {
void _mlir_ciface_mlir_gccloopsex1_vec(MemRef<int, 1> *output,
                              MemRef<int, 1> *input1,
                              MemRef<int, 1> *input2);
}

// Define input and output sizes.
intptr_t sizesInputArrayMLIRGccLoopsEx1Vec_1[1] = {100000};
intptr_t sizesInputArrayMLIRGccLoopsEx1Vec_2[1] = {100000};
intptr_t sizesOutputArrayMLIRGccLoopsEx1Vec[1] = {100000};
// Define the MemRef container for inputs and output.
MemRef<int, 1> inputMLIRGccLoopsEx1Vec_1(sizesInputArrayMLIRGccLoopsEx1Vec_1, 2);
MemRef<int, 1> inputMLIRGccLoopsEx1Vec_2(sizesInputArrayMLIRGccLoopsEx1Vec_2, 3);
MemRef<int, 1> outputMLIRGccLoopsEx1Vec(sizesOutputArrayMLIRGccLoopsEx1Vec, 0);

static void MLIR_GccLoopsEx1Vec(benchmark::State &state) {
  for (auto _ : state) {
    for (int i = 0; i < state.range(0); ++i) {
      _mlir_ciface_mlir_gccloopsex1_vec(&outputMLIRGccLoopsEx1Vec, &inputMLIRGccLoopsEx1Vec_1,
                               &inputMLIRGccLoopsEx1Vec_2);
    }
  }
}

// Register benchmarking function.
BENCHMARK(MLIR_GccLoopsEx1Vec)->Arg(1);

// Generate result image.
void generateResultMLIRGccLoopsEx1Vec() {
  // Define the MemRef descriptor for inputs and output.
  MemRef<int, 1> input1(sizesInputArrayMLIRGccLoopsEx1Vec_1, 2);
  MemRef<int, 1> input2(sizesInputArrayMLIRGccLoopsEx1Vec_2, 3);
  MemRef<int, 1> output(sizesOutputArrayMLIRGccLoopsEx1Vec, 0);
  // Run the gccloopsex1.
  _mlir_ciface_mlir_gccloopsex1_vec(&output, &input1, &input2);
  // Print the output.
  std::cout << "--------------------------------------------------------"
            << std::endl;
  std::cout << "MLIR_GccLoopsEx1Vec: MLIR GccLoopsEx1Vec Operation" << std::endl;
  std::cout << "[ ";
  for (size_t i = 0; i < output.getSize(); i++) {
    std::cout << output.getData()[i] << " ";
  }
  std::cout << "]" << std::endl;
}
