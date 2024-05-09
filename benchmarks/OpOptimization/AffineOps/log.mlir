module {
  func.func @vector_add_2d(%arg0: index, %arg1: index) -> f32 {
    %alloc = memref.alloc(%arg0, %arg1) : memref<?x?xf32>
    %alloc_0 = memref.alloc(%arg0, %arg1) : memref<?x?xf32>
    %alloc_1 = memref.alloc(%arg0, %arg1) : memref<?x?xf32>
    %cst = arith.constant 1.000000e+00 : f32
    %cst_2 = arith.constant 2.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %arg0 step %c1 {
      %c0_7 = arith.constant 0 : index
      %c128 = arith.constant 128 : index
      scf.for %arg3 = %c0_7 to %arg1 step %c128 {
        %cst_8 = arith.constant dense<1.000000e+00> : vector<128xf32>
        vector.transfer_write %cst_8, %alloc[%arg2, %arg3] : vector<128xf32>, memref<?x?xf32>
      }
    }
    %c0_3 = arith.constant 0 : index
    %c1_4 = arith.constant 1 : index
    scf.for %arg2 = %c0_3 to %arg0 step %c1_4 {
      %c0_7 = arith.constant 0 : index
      %c128 = arith.constant 128 : index
      scf.for %arg3 = %c0_7 to %arg1 step %c128 {
        %cst_8 = arith.constant dense<2.000000e+00> : vector<128xf32>
        vector.transfer_write %cst_8, %alloc_0[%arg2, %arg3] : vector<128xf32>, memref<?x?xf32>
      }
    }
    %c0_5 = arith.constant 0 : index
    %c1_6 = arith.constant 1 : index
    scf.for %arg2 = %c0_5 to %arg0 step %c1_6 {
      %c0_7 = arith.constant 0 : index
      %c128 = arith.constant 128 : index
      scf.for %arg3 = %c0_7 to %arg1 step %c128 {
        %cst_8 = arith.constant dense<2.000000e+00> : vector<128xf32>
        %cst_9 = arith.constant dense<1.000000e+00> : vector<128xf32>
        %cst_10 = arith.constant 0.000000e+00 : f32
        %1 = vector.transfer_read %alloc[%arg2, %arg3], %cst_10 : memref<?x?xf32>, vector<128xf32>
        %cst_11 = arith.constant 0.000000e+00 : f32
        %2 = vector.transfer_read %alloc_0[%arg2, %arg3], %cst_11 : memref<?x?xf32>, vector<128xf32>
        %3 = arith.addf %1, %2 : vector<128xf32>
        %4 = arith.addf %3, %cst_9 : vector<128xf32>
        %5 = arith.addf %3, %cst_8 : vector<128xf32>
        %6 = arith.addf %5, %4 : vector<128xf32>
        vector.transfer_write %6, %alloc_1[%arg2, %arg3] : vector<128xf32>, memref<?x?xf32>
      }
    }
    %c7 = arith.constant 7 : index
    %c42 = arith.constant 42 : index
    %0 = memref.load %alloc_1[%c7, %c42] : memref<?x?xf32>
    return %0 : f32
  }
}

