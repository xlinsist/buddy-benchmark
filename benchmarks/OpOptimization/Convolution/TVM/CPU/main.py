from mxnet_conv_baseline import *
from convolution_manual import *
from convolution_auto import *

import numpy
import timeit
import tvm.testing
import mxnet as mx

import os
os.environ['KMP_AFFINITY']='granularity=fine,noduplicates,compact,1,0'

# ------------------------------------------------------------------------------
# Helper Function
# ------------------------------------------------------------------------------
def evaluate_operation(s, vars, target, inputs, optimization, log):
  """Evaluate operation correctness and print the performance information.
  Args:
    s: The schedule to be built.
    vars: The argument lists to the function.
    target: The target and option of the compilation.
    inputs: The input tensors.
    standard: The standard result for correctness evaluation.
    optimization: The name of the optimization.
    log: The log list.
  """
  func = tvm.build(s, vars, target=target)
  dev = tvm.device(target.kind.name, 0)
  data_x, data_k, data_y= inputs
  evaluator = func.time_evaluator(func.entry_name, dev, number=10)
  mean_time = evaluator(data_x, data_k, data_y).mean * 1000  # Convert to milliseconds
  log.append((optimization, mean_time))


def report_performance(log):
  """Convert the log into a performance table.
  Args:
    log: The log list.
  """
  baseline = log[0][1]
  header = "Benchmark".ljust(30) + "\t" + "Time".rjust(
      10) + "\t" + "SpeedUp".rjust(10)
  split_line = "-" * 70
  print(split_line)
  print(header)
  print(split_line)
  for result in log:
    formatted_time = "{:.4f}".format(result[1])
    formatted_performance = "{:.4f}".format(baseline / result[1])
    print("\033[32m%s\033[0m\t\033[33m%s\033[0m\t\033[34m%s\033[0m" %
          (result[0].ljust(30), str(formatted_time + " ms").rjust(10),
           str(formatted_performance).rjust(10)))

# C1
# N=1
# F=192
# C=1536
# H_k=1
# W_k=1
# H_o=7
# W_o=7

# C2
# N=1
# F=1536
# C=192
# H_k=1
# W_k=1
# H_o=7
# W_o=7

# C3
# N=1
# F=384
# C=48
# H_k=3
# W_k=3
# H_o=28
# W_o=28

# C4
# N=1
# F=32
# C=3
# H_k=3
# W_k=3
# H_o=223
# W_o=223

# C5
N=1
F=96
C=32
H_k=3
W_k=3
H_o=112
W_o=112

# C6
# N=1
# F=64
# C=64
# H_k=3
# W_k=3
# H_o=56
# W_o=56

import sys

def main():
  # ----------------------------------------------------------------------------
  # Initialization and Baseline
  # ----------------------------------------------------------------------------
  # Initialize the log list.
  log = []
  size = 64,H_o+H_k-1,W_o+W_k-1
  # target = tvm.target.Target(target="llvm", host="llvm")
  target = tvm.target.Target("llvm -mcpu=skylake-avx512")
  dtype = "float32"
  c,n,k = size
  oc = F
  ic = C
  p = H_k
  s = W_k
  data_x, data_k, data_y = get_conv_data(oc, ic, n, k, p, s,tvm.nd.array)
  

  mxnet_times = bench_conv_mxnet(size)

  # ----------------------------------------------------------------------------
  # Register Benchmarks and Dump Report
  # ----------------------------------------------------------------------------
  # Register default schedule.

  sch, arg_bufs = default_conv(oc, ic, n, k, p, s)
  evaluate_operation(sch,
                      arg_bufs,
                      target=target,
                      inputs=(data_x, data_k, data_y),
                      optimization="default_conv",
                      log=log)

  sch, arg_bufs = blocked_cached_conv(oc, ic, n, k, p, s) 
  evaluate_operation(sch,
                      arg_bufs,
                      target=target,
                      inputs=(data_x, data_k, data_y),
                      optimization="blocked_cached_conv",
                      log=log)

  sch, arg_bufs = packed_cached_conv(oc, ic, n, k, p, s)
  # print(arg_bufs)
  evaluate_operation(sch,
                      arg_bufs,
                      target=target,
                      inputs=(data_x, data_k, data_y),
                      optimization="packed_cached_conv",
                      log=log)

  
  sch, arg_bufs = conv_auto(oc, ic, n, k, p, s)
  evaluate_operation(sch,
                      arg_bufs,
                      target=target,
                      inputs=(data_x, data_k, data_y),
                      optimization="auto_conv",
                      log=log)

  
  # Register numpy case.
  log.append(("mxnet_baseline", mxnet_times  * 1000))  # Milliseconds
  # Dump the performance table.
  report_performance(log)

  print(N, F, C, H_k, W_k, H_o, W_o)


if __name__ == "__main__":
  main()