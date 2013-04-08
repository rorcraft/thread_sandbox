package main

import (
  "runtime"
  "fmt"
  "database/sql"
  _ "github.com/go-sql-driver/mysql"
  "testing"
)

func main() {
  runtime.GOMAXPROCS(2)

  bmResult := testing.Benchmark(Benchmark_sleeper)
  fmt.Println("sleep(3)", bmResult)
  bmResult = testing.Benchmark(Benchmark_go_sleeper)
  fmt.Println("5 go func", bmResult)
  bmResult = testing.Benchmark(Benchmark_fib)
  fmt.Println("fib(32)", bmResult)
  bmResult = testing.Benchmark(Benchmark_go_fib)
  fmt.Println("5 go fib(32)", bmResult)

}


func Benchmark_sleeper(b *testing.B) {
  db, e := sql.Open("mysql", "root@tcp(localhost:3306)/")
  if e != nil {
    panic(e.Error())
  }
  defer db.Close()
  db.Exec("SELECT sleep(3)")
}

func Benchmark_go_sleeper(b *testing.B) {
  db, e := sql.Open("mysql", "root@tcp(localhost:3306)/")
  if e != nil {
    panic(e.Error())
  }
  defer db.Close()

  ch := make(chan sql.Result, 5)
  for i := 0; i < 5; i++ {
    go func() {
      result, e := db.Exec("SELECT sleep(3)")
      if e != nil {
        panic(e.Error())
      }
      ch <- result
    }()
  }
  for i := 0; i < 5; i++ {
    <-ch
  }

}

func fib(n int) int {
  var r int
  if n < 2 {
    r = n
  } else {
    r = fib(n - 1) + fib(n - 2)
  }
  return r
}

func Benchmark_fib(b *testing.B) {
  fib(32)
}

func Benchmark_go_fib(b *testing.B) {
  ch := make(chan int, 5)
  for i := 0; i < 5; i++ {
    go func() {
      ch <- fib(32)
    }()
  }
  for i := 0; i < 5; i++ {
    <-ch
  }

}
