Testing ruby threading, async IO
==============

__Ruby 1.9.3 with Threads__
```
Activerecord IO:
              user     system      total        real
db sleep(3)   0.010000   0.010000   0.020000 (  3.140850)
1 thread      0.000000   0.000000   0.000000 (  3.001809)
5 threads     0.010000   0.000000   0.010000 (  6.004460)

Computation:
              user     system      total        real
fib(32)       0.780000   0.000000   0.780000 (  0.800027)
5 threads     3.750000   0.010000   3.760000 (  3.793712)
```
__JRuby 1.7.3 with Threads__
```
Activerecord IO:
              user     system      total        real
db sleep(3)   0.880000   0.030000   0.910000 (  3.662000)
1 thread      0.210000   0.010000   0.220000 (  3.132000)
5 threads     0.700000   0.050000   0.750000 (  6.272000)

Computation:
              user     system      total        real
fib(32)       0.430000   0.010000   0.440000 (  0.360000)
5 threads     1.320000   0.000000   1.320000 (  0.753000)
```
