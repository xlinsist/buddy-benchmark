func.func @vector_transpose(%A : memref<?x?x?xf32>, %B : memref<?x?x?xf32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %M = memref.dim %A, %c0 : memref<?x?x?xf32>
  %N = memref.dim %A, %c1 : memref<?x?x?xf32>
  %P = memref.dim %A, %c2 : memref<?x?x?xf32>

  affine.for %i0 = 0 to %M {
    affine.for %i1 = 0 to %N {
      affine.for %i2 = 0 to %P {
        %a2 = affine.load %A[%i0, %i1, %i2] : memref<?x?x?xf32>
      }
    }
  }

  affine.for %i3 = 0 to %M {
    affine.for %i4 = 0 to %N {
      affine.for %i5 = 0 to %P {
        %a5 = affine.load %A[%i4, %i5, %i3] : memref<?x?x?xf32>
        affine.store %a5, %B[%i3, %i4, %i5] : memref<?x?x?xf32>
      }
    }
  }
  return
}
