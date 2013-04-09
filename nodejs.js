// var Benchmark  = require('benchmark');
var Fiber = require('fibers');
var Future = require('fibers/future')

var mysql      = require('mysql');
var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root'
});

connection.connect();

var measure = function(name, func)  {
  Fiber(function() {
    var start = new Date;
    func();
    var elapsed_time = new Date - start;
    console.log(name + ": " + elapsed_time + "ms")
  }).run();
};

function sleeper() {
  var fiber = Fiber.current;
  connection.query('SELECT sleep(3)', function(err, rows, fields) {
    if (err) throw err;
    fiber.run();
  });
  Fiber.yield();
}

function async_sleepers() {
  var fiber = Fiber.current;
  var ready_count = 0
  var concurrent  = 5
  var ready = function(err, rows, fields) {
    if (err) throw err;
    ready_count++;
    if(ready_count == 5) {
      fiber.run();
    }
  }
  while(concurrent--) {
    connection.query('SELECT sleep(3)', ready);
  }
  console.log("after loop")
  Fiber.yield();
}

measure("sleep(3)", sleeper);
measure("5 concurrent", async_sleepers);

connection.end();
