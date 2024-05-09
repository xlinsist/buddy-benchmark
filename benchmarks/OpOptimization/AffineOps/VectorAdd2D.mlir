func.func @vector_add_2d(%M : index, %N : index) -> f32 {
  %A = memref.alloc (%M, %N) : memref<?x?xf32, 0>
  %B = memref.alloc (%M, %N) : memref<?x?xf32, 0>
  %C = memref.alloc (%M, %N) : memref<?x?xf32, 0>
  %f1 = arith.constant 1.0 : f32
  %f2 = arith.constant 2.0 : f32
  affine.for %i0 = 0 to %M {
    affine.for %i1 = 0 to %N {
      affine.store %f1, %A[%i0, %i1] : memref<?x?xf32, 0>
    }
  }
  affine.for %i2 = 0 to %M {
    affine.for %i3 = 0 to %N {
      affine.store %f2, %B[%i2, %i3] : memref<?x?xf32, 0>
    }
  }
  affine.for %i4 = 0 to %M {
    affine.for %i5 = 0 to %N {
      %a5 = affine.load %A[%i4, %i5] : memref<?x?xf32, 0>
      %b5 = affine.load %B[%i4, %i5] : memref<?x?xf32, 0>
      %s5 = arith.addf %a5, %b5 : f32
      %s6 = arith.addf %s5, %f1 : f32
      %s7 = arith.addf %s5, %f2 : f32
      %s8 = arith.addf %s7, %s6 : f32
      affine.store %s8, %C[%i4, %i5] : memref<?x?xf32, 0>
    }
  }
  %c7 = arith.constant 7 : index
  %c42 = arith.constant 42 : index
  %res = affine.load %C[%c7, %c42] : memref<?x?xf32, 0>
  return %res : f32
}