// var Benchmark  = require('benchmark');
var Fiber = require('fibers');
var Future = require('fibers/future')

var mysql      = require('mysql');

var pool  = mysql.createPool({
  host     : 'localhost',
  user     : 'root'
});

var measure = function(name, func, process_fiber)  {
  Fiber(function() {
    var start = new Date;
    func();
    var elapsed_time = new Date - start;
    console.log(name + ": " + elapsed_time + "ms")
    if (process_fiber) {
      process_fiber.run();
    }
  }).run();
};

function sleeper() {
  var fiber = Fiber.current;
  pool.getConnection(function(err, connection) {
    connection.query('SELECT sleep(3)', function(err, rows, fields) {
      if (err) throw err;
      fiber.run();
      connection.end();
    });
  });
  Fiber.yield();
}

function async_sleepers() {
  var fiber = Fiber.current;
  var ready_count = 0
  var concurrent  = 5

  while(concurrent--) {
    pool.getConnection(function(err, connection) {
      var ready = function(err, rows, fields) {
        if (err) throw err;
        ready_count++;
        connection.end();
        if(ready_count == 5) {
          fiber.run();
        }
      }
      connection.query('SELECT sleep(3)', ready);
    });
  }
  Fiber.yield();
}

function fib(n) {
  n < 2 ? n : fib(n - 1) + fib(n - 2);
}

function fib32() {
  fib(32);
}

function five_fib32() {
  var times = 5;
  while(times--) {
    fib(32);
  }
}

Fiber(function() {
  var process_fiber = Fiber.current;
  measure("sleep(3)", sleeper, process_fiber);
  Fiber.yield();
  measure("5 concurrent", async_sleepers, process_fiber);
  Fiber.yield();
  measure("fib(32)", fib32, null);

  measure("5 fib(32)", five_fib32, null);

  process.exit();
}).run();

