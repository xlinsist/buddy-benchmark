#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1)[s0, s1] -> (d0 * s1 + s0 + d1)>
#map2 = affine_map<(d0)[s0] -> (d0, s0 - 1)>
#map3 = affine_map<(d0, d1) -> (0)>
#map4 = affine_map<(d0) -> (d0 + 16)>
module {
  func.func @matmul_ocv(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>, %arg2: memref<?x?xf32>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c0_0 = arith.constant 0 : index
    %dim = memref.dim %arg0, %c0_0 : memref<?x?xf32>
    %c1_1 = arith.constant 1 : index
    %dim_2 = memref.dim %arg1, %c1_1 : memref<?x?xf32>
    %c1_3 = arith.constant 1 : index
    %dim_4 = memref.dim %arg0, %c1_3 : memref<?x?xf32>
    affine.for %arg3 = #map(%c0) to #map(%dim_2) step 32 {
      affine.for %arg4 = #map(%c0) to #map(%dim) {
        %subview = memref.subview %arg0[%arg4, %c0] [%c1, %dim_4] [%c1, %c1] : memref<?x?xf32> to memref<?x?xf32, #map1>
        %0 = affine.min #map2(%arg4)[%dim]
        %subview_5 = memref.subview %arg2[%0, %c0] [%c1, %dim_2] [%c1, %c1] : memref<?x?xf32> to memref<?x?xf32, #map1>
        affine.for %arg5 = #map(%c0) to #map(%dim_4) {
          %cst = arith.constant 0.000000e+00 : f32
          %1 = vector.transfer_read %subview[%c0, %arg5], %cst {permutation_map = #map3} : memref<?x?xf32, #map1>, vector<16xf32>
          %2 = affine.apply #map(%arg3)
          %cst_6 = arith.constant 0.000000e+00 : f32
          %3 = vector.transfer_read %subview_5[%c0, %2], %cst_6 : memref<?x?xf32, #map1>, vector<16xf32>
          %4 = affine.apply #map4(%arg3)
          %cst_7 = arith.constant 0.000000e+00 : f32
          %5 = vector.transfer_read %subview_5[%c0, %4], %cst_7 : memref<?x?xf32, #map1>, vector<16xf32>
          %cst_8 = arith.constant 0.000000e+00 : f32
          %6 = vector.transfer_read %arg1[%arg5, %arg3], %cst_8 : memref<?x?xf32>, vector<16xf32>
          %7 = affine.apply #map4(%arg3)
          %cst_9 = arith.constant 0.000000e+00 : f32
          %8 = vector.transfer_read %arg1[%arg5, %7], %cst_9 : memref<?x?xf32>, vector<16xf32>
          %9 = vector.fma %1, %6, %3 : vector<16xf32>
          %10 = vector.fma %1, %8, %5 : vector<16xf32>
          %11 = affine.apply #map(%arg3)
          vector.transfer_write %9, %subview_5[%c0, %11] : vector<16xf32>, memref<?x?xf32, #map1>
          %12 = affine.apply #map4(%arg3)
          vector.transfer_write %10, %subview_5[%c0, %12] : vector<16xf32>, memref<?x?xf32, #map1>
        }
      }
    }
    return
  }
}
