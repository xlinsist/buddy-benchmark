//===- MLIRGccLoopsEx1.mlir ----------------------------------------------------===//
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
// This file provides the MLIR GccLoopsEx1 function.
//
//===----------------------------------------------------------------------===//

#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> (d0 ceildiv 256)>

func.func @mlir_gccloopsex1_vec(%A: memref<?xi32>, %B: memref<?xi32>,
                       %C: memref<?xi32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c256 = arith.constant 256 : index
  %c0_vector = arith.constant dense<0> : vector<256xi32>
  %n = memref.dim %B, %c0 : memref<?xi32>

  affine.for %idx = #map0(%c0) to #map1(%n) {
    %curlen = arith.muli %idx, %c256 : index
    %remain = arith.subi %n, %curlen : index
    %cmp = arith.cmpi sge, %remain, %c256 : index
    scf.if %cmp {
      %x_vector = affine.vector_load %B[%c0] : memref<?xi32>, vector<256xi32>
      %y_vector = affine.vector_load %C[%c0] : memref<?xi32>, vector<256xi32>
      %add_vector = arith.addi %x_vector, %y_vector : vector<256xi32>
      affine.vector_store %add_vector, %C[%c0] : memref<?xi32>, vector<256xi32>
    } else {
      %mask256 = vector.create_mask %remain : vector<256xi1>
      %remain_i32 = arith.index_cast %remain : index to i32
      %x_vector = vector.maskedload %B[%curlen], %mask256, %c0_vector : memref<?xi32>, vector<256xi1>, vector<256xi32> into vector<256xi32>
      %y_vector = vector.maskedload %C[%curlen], %mask256, %c0_vector : memref<?xi32>, vector<256xi1>, vector<256xi32> into vector<256xi32>
      %add_vector = arith.addi %x_vector, %y_vector : vector<256xi32>
      vector.maskedstore %C[%curlen], %mask256, %add_vector : memref<?xi32>, vector<256xi1>, vector<256xi32>
    }
  }

  // %x_vector = affine.vector_load %B[%c0] : memref<?xi32>, vector<100000xi32>
  // %y_vector = affine.vector_load %C[%c0] : memref<?xi32>, vector<100000xi32>
  // %add_vector = arith.addi %x_vector, %y_vector : vector<100000xi32>
  // affine.vector_store %add_vector, %C[%c0] : memref<?xi32>, vector<100000xi32>

  return
}
