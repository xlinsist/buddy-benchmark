#map = affine_map<(d0) -> (d0 floordiv 9)>
#map1 = affine_map<(d0, d1) -> (d0 floordiv 223 + (d1 mod 9) floordiv 3)>
#map2 = affine_map<(d0, d1) -> (d0 + d1 - (d0 floordiv 223) * 223 - (d1 floordiv 3) * 3)>
#map3 = affine_map<(d0) -> (d0 ceildiv STEP_PLACEHOLDER)>

func.func @batch_matmul_optimize_STEP_PLACEHOLDER(%a : memref<1x32x27xf32>, %b : memref<1x27x49729xf32>, %c : memref<1x32x49729xf32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %step = arith.constant STEP_PLACEHOLDER : index
  %c0_f32 = arith.constant 0.0 : f32
  %c0_f32_vec = vector.splat %c0_f32 : vector<STEP_PLACEHOLDERxf32>

  %a_row = memref.dim %a, %c1 : memref<1x32x27xf32>
  %a_col = memref.dim %a, %c2 : memref<1x32x27xf32>
  %b_row = memref.dim %b, %c1 : memref<1x27x49729xf32>
  %b_col = memref.dim %b, %c2 : memref<1x27x49729xf32>

  affine.for %b_row_idx = 0 to %b_row {
    affine.for %a_row_idx = 0 to %a_row {
      affine.for %b_col_idx = 0 to #map3(%b_col) {
        %a_ele = memref.load %a[%c0, %a_row_idx, %b_row_idx] : memref<1x32x27xf32>
        %a_vec = vector.broadcast %a_ele : f32 to vector<STEP_PLACEHOLDERxf32>
        // Check tail.
        %b_col_cur = arith.muli %b_col_idx, %step : index
        %tail_len = arith.subi %b_col, %b_col_cur : index
        %tail_flag = arith.cmpi sge, %tail_len, %step : index
        scf.if %tail_flag {
          %b_vec = affine.vector_load %b[%c0, %b_row_idx, %b_col_idx * STEP_PLACEHOLDER] : memref<1x27x49729xf32>, vector<STEP_PLACEHOLDERxf32>
          %c_vec = affine.vector_load %c[%c0, %a_row_idx, %b_col_idx * STEP_PLACEHOLDER] : memref<1x32x49729xf32>, vector<STEP_PLACEHOLDERxf32>
          %result_vec = vector.fma %a_vec, %b_vec, %c_vec : vector<STEP_PLACEHOLDERxf32>
          affine.vector_store %result_vec, %c[%c0, %a_row_idx, %b_col_idx * STEP_PLACEHOLDER] : memref<1x32x49729xf32>, vector<STEP_PLACEHOLDERxf32>
        } else {
          %mask_vec = vector.create_mask %tail_len : vector<STEP_PLACEHOLDERxi1>
          %b_col_idx_tail = arith.muli %b_col_idx, %step : index
          %b_vec_tail = vector.maskedload %b[%c0, %b_row_idx, %b_col_idx_tail], %mask_vec, %c0_f32_vec : memref<1x27x49729xf32>, vector<STEP_PLACEHOLDERxi1>, vector<STEP_PLACEHOLDERxf32> into vector<STEP_PLACEHOLDERxf32>
          %c_vec_tail = vector.maskedload %c[%c0, %a_row_idx, %b_col_idx_tail], %mask_vec, %c0_f32_vec : memref<1x32x49729xf32>, vector<STEP_PLACEHOLDERxi1>, vector<STEP_PLACEHOLDERxf32> into vector<STEP_PLACEHOLDERxf32>
          %result_vec_tail = vector.fma %a_vec, %b_vec_tail, %c_vec_tail : vector<STEP_PLACEHOLDERxf32>
          vector.maskedstore %c[%c0, %a_row_idx, %b_col_idx_tail], %mask_vec, %result_vec_tail : memref<1x32x49729xf32>, vector<STEP_PLACEHOLDERxi1>, vector<STEP_PLACEHOLDERxf32>
        }
      }
    }
  }
  return
}

func.func @conv2d_nchw_fchw_im2col_STEP_PLACEHOLDER(%input: memref<?x?x?x?xf32>, %kernel: memref<?x?x?x?xf32>, %output: memref<?x?x?x?xf32>) {
  %input_specific = memref.cast %input : memref<?x?x?x?xf32> to memref<1x3x225x225xf32>
  %kernel_specific = memref.cast %kernel : memref<?x?x?x?xf32> to memref<32x3x3x3xf32>
  %output_specific = memref.cast %output : memref<?x?x?x?xf32> to memref<1x32x223x223xf32>

  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c27 = arith.constant 27 : index
  %c49729 = arith.constant 49729 : index
  %c32 = arith.constant 32 : index
  %kernel_collapse = memref.collapse_shape %kernel_specific [[0], [1, 2, 3]] : memref<32x3x3x3xf32> into memref<32x27xf32>
  %output_collapse = memref.collapse_shape %output_specific [[0], [1], [2, 3]] : memref<1x32x223x223xf32> into memref<1x32x49729xf32>
  %input_collapse = memref.alloc() {alignment = 64 : i64} : memref<1x27x49729xf32>
  scf.for %arg3 = %c0 to %c1 step %c1 {
    scf.for %arg4 = %c0 to %c27 step %c1 {
      scf.for %arg5 = %c0 to %c49729 step %c1 {
        %0 = affine.apply #map(%arg4)
        %1 = affine.apply #map1(%arg5, %arg4)
        %2 = affine.apply #map2(%arg5, %arg4)
        %3 = memref.load %input_specific[%arg3, %0, %1, %2] : memref<1x3x225x225xf32>
        memref.store %3, %input_collapse[%arg3, %arg4, %arg5] : memref<1x27x49729xf32>
      }
    }
  }
  // Implement optimized GEMM.
  %kernel_expand = memref.expand_shape %kernel_collapse [[0, 1], [2]] : memref<32x27xf32> into memref<1x32x27xf32>
  func.call @batch_matmul_optimize_STEP_PLACEHOLDER(%kernel_expand, %input_collapse, %output_collapse) : (memref<1x32x27xf32>, memref<1x27x49729xf32>, memref<1x32x49729xf32>) -> ()
  // Apply col2im.
  %result_mem = memref.expand_shape %output_collapse [[0], [1], [2, 3]] : memref<1x32x49729xf32> into memref<1x32x223x223xf32>
  memref.dealloc %input_collapse : memref<1x27x49729xf32>
  return
}
