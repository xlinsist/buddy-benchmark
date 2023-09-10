#map = affine_map<(d0) -> (d0 floordiv 7)>
#map1 = affine_map<(d0) -> (d0 mod 7)>
#map3 = affine_map<(d0) -> (d0 ceildiv STEP_PLACEHOLDER)>

func.func @batch_matmul_optimize_STEP_PLACEHOLDER(%a : memref<1x192x1536xf32>, %b : memref<1x1536x49xf32>, %c : memref<1x192x49xf32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %step = arith.constant STEP_PLACEHOLDER : index
  %c0_f32 = arith.constant 0.0 : f32
  %c0_f32_vec = vector.splat %c0_f32 : vector<STEP_PLACEHOLDERxf32>

  %a_row = memref.dim %a, %c1 : memref<1x192x1536xf32>
  %a_col = memref.dim %a, %c2 : memref<1x192x1536xf32>
  %b_row = memref.dim %b, %c1 : memref<1x1536x49xf32>
  %b_col = memref.dim %b, %c2 : memref<1x1536x49xf32>

  affine.for %b_row_idx = 0 to %b_row {
    affine.for %a_row_idx = 0 to %a_row {
      affine.for %b_col_idx = 0 to #map3(%b_col) {
        %a_ele = memref.load %a[%c0, %a_row_idx, %b_row_idx] : memref<1x192x1536xf32>
        %a_vec = vector.broadcast %a_ele : f32 to vector<STEP_PLACEHOLDERxf32>
        // Check tail.
        %b_col_cur = arith.muli %b_col_idx, %step : index
        %tail_len = arith.subi %b_col, %b_col_cur : index
        %tail_flag = arith.cmpi sge, %tail_len, %step : index
        scf.if %tail_flag {
          %b_vec = affine.vector_load %b[%c0, %b_row_idx, %b_col_idx * STEP_PLACEHOLDER] : memref<1x1536x49xf32>, vector<STEP_PLACEHOLDERxf32>
          %c_vec = affine.vector_load %c[%c0, %a_row_idx, %b_col_idx * STEP_PLACEHOLDER] : memref<1x192x49xf32>, vector<STEP_PLACEHOLDERxf32>
          %result_vec = vector.fma %a_vec, %b_vec, %c_vec : vector<STEP_PLACEHOLDERxf32>
          affine.vector_store %result_vec, %c[%c0, %a_row_idx, %b_col_idx * STEP_PLACEHOLDER] : memref<1x192x49xf32>, vector<STEP_PLACEHOLDERxf32>
        } else {
          %mask_vec = vector.create_mask %tail_len : vector<STEP_PLACEHOLDERxi1>
          %b_col_idx_tail = arith.muli %b_col_idx, %step : index
          %b_vec_tail = vector.maskedload %b[%c0, %b_row_idx, %b_col_idx_tail], %mask_vec, %c0_f32_vec : memref<1x1536x49xf32>, vector<STEP_PLACEHOLDERxi1>, vector<STEP_PLACEHOLDERxf32> into vector<STEP_PLACEHOLDERxf32>
          %c_vec_tail = vector.maskedload %c[%c0, %a_row_idx, %b_col_idx_tail], %mask_vec, %c0_f32_vec : memref<1x192x49xf32>, vector<STEP_PLACEHOLDERxi1>, vector<STEP_PLACEHOLDERxf32> into vector<STEP_PLACEHOLDERxf32>
          %result_vec_tail = vector.fma %a_vec, %b_vec_tail, %c_vec_tail : vector<STEP_PLACEHOLDERxf32>
          vector.maskedstore %c[%c0, %a_row_idx, %b_col_idx_tail], %mask_vec, %result_vec_tail : memref<1x192x49xf32>, vector<STEP_PLACEHOLDERxi1>, vector<STEP_PLACEHOLDERxf32>
        }
      }
    }
  }
  return
}

func.func @conv2d_nchw_fchw_im2col_STEP_PLACEHOLDER(%input: memref<?x?x?x?xf32>, %kernel: memref<?x?x?x?xf32>, %output: memref<?x?x?x?xf32>) {
  %input_specific = memref.cast %input : memref<?x?x?x?xf32> to memref<1x1536x7x7xf32>
  %kernel_specific = memref.cast %kernel : memref<?x?x?x?xf32> to memref<192x1536x1x1xf32>
  %output_specific = memref.cast %output : memref<?x?x?x?xf32> to memref<1x192x7x7xf32>

  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c1536 = arith.constant 1536 : index
  %c49 = arith.constant 49 : index
  %c192 = arith.constant 192 : index
  %kernel_collapse = memref.collapse_shape %kernel_specific [[0], [1, 2, 3]] : memref<192x1536x1x1xf32> into memref<192x1536xf32>
  %output_collapse = memref.collapse_shape %output_specific [[0], [1], [2, 3]] : memref<1x192x7x7xf32> into memref<1x192x49xf32>
  %input_collapse = memref.alloc() {alignment = 64 : i64} : memref<1x1536x49xf32>
  scf.for %arg3 = %c0 to %c1 step %c1 {
    scf.for %arg4 = %c0 to %c1536 step %c1 {
      scf.for %arg5 = %c0 to %c49 step %c1 {
        %0 = affine.apply #map(%arg5)
        %1 = affine.apply #map1(%arg5)
        %3 = memref.load %input_specific[%arg3, %arg4, %0, %1] : memref<1x1536x7x7xf32>
        memref.store %3, %input_collapse[%arg3, %arg4, %arg5] : memref<1x1536x49xf32>
      }
    }
  }
  // Implement optimized GEMM.
  %kernel_expand = memref.expand_shape %kernel_collapse [[0, 1], [2]] : memref<192x1536xf32> into memref<1x192x1536xf32>
  func.call @batch_matmul_optimize_STEP_PLACEHOLDER(%kernel_expand, %input_collapse, %output_collapse) : (memref<1x192x1536xf32>, memref<1x1536x49xf32>, memref<1x192x49xf32>) -> ()
  // Apply col2im.
  %result_mem = memref.expand_shape %output_collapse [[0], [1], [2, 3]] : memref<1x192x49xf32> into memref<1x192x7x7xf32>
  memref.dealloc %input_collapse : memref<1x1536x49xf32>
  return
}
