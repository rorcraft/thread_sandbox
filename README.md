Testing ruby threading, async IO
==============

__Ruby 1.9.3 with Threads__
```
Activerecord IO:
              user     system      total        real
db sleep(3)   0.010000   0.010000   0.020000 (  3.140850)
1 thread      0.000000   0.000000   0.000000 (  3.001809)
5 threads     0.010000   0.000000   0.010000 (  3.028423)

10 http       0.000000   0.000000   0.000000 (  0.709238)
10 threads    0.010000   0.000000   0.010000 (  0.066954)

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

__Ruby 1.9.3 EM::Synchrony__

```
              user     system      total        real
1 sleep(3)    0.020000   0.000000   0.020000 (  3.116425)
5 concurrent  0.010000   0.000000   0.010000 (  3.002499)
```

__JRuby 1.7.3 EM::Synchrony jdbc-mysql (not evented)__

```
              user     system      total        real
1 sleep(3)    1.020000   0.040000   1.060000 (  3.830000)
5 concurrent  0.050000   0.010000   0.060000 ( 15.032000)

```

__Ruby 1.9.3 Celluloid__

```
ActiveRecord IO:
              user     system      total        real
1 sleep(3)    0.020000   0.000000   0.020000 (  3.119160)
5 concurrent  0.000000   0.000000   0.000000 (  3.008427)

Computation:
              user     system      total        real
fib(32)       0.870000   0.000000   0.870000 (  0.884170)
5 actors      4.450000   0.010000   4.460000 (  4.518849)
```
__JRuby 1.7.3 Celluloid__

```
ActiveRecord IO:
              user     system      total        real
1 sleep(3)    1.030000   0.050000   1.080000 (  3.929000)
5 concurrent  0.990000   0.060000   1.050000 (  3.490000)

Computation:
              user     system      total        real
fib(32)       0.800000   0.020000   0.820000 (  0.760000)
5 actors      3.510000   0.070000   3.580000 (  2.091000)
```

__Interesting Golang performance__

```
sleep(3)      1                3003332000 ns/op
5 go func     1                3005076000 ns/op
fib(32)       1000000000	         0.04 ns/op
5 go fib(32)  1000000000	         0.13 ns/op
```

__Nodejs__
```
sleep(3):     3013ms
5 concurrent: 3017ms
fib(32):       591ms
5 fib(32):    2867ms
```
