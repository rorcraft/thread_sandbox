require 'bundler'
Bundler.require(:default, :actor)
require 'benchmark'
require 'celluloid/autostart'

adapter = RUBY_PLATFORM =~ /java/ ? 'mysql' : 'mysql2'
ActiveRecord::Base.establish_connection(adapter: adapter, host: "localhost", username: "root", pool: 10)

puts "ActiveRecord IO:"

class Sleep
  include Celluloid

  def goto_sleep
    @result = ActiveRecord::Base.connection.execute("SELECT sleep(3)")
  end

  def result
    @result
  end
end


Benchmark.bm do |b|
  b.report("1 sleep(3)") do
    sleeper = Sleep.new
    sleeper.goto_sleep
    sleeper.result
  end

  b.report("5 concurrent") do
    results = []
    5.times do
      sleeper = Sleep.new
      sleeper.async.goto_sleep
      results << sleeper
    end
    results.map(&:result)
  end
end


puts "Computation:"



class Fib
  include Celluloid

  def initialize(n)
    @n = n
  end

  def fib(n = @n)
    @result = n < 2 ? n : fib(n-1) + fib(n-2)
  end

  def result
    @result
  end
end

Benchmark.bm do |b|

  b.report("fib(32)") do
    f = Fib.new(32)
    f.fib
    f.result
  end

  b.report("5 actors") do
    actors = []
    5.times do
      f = Fib.new(32)
      actors << f
      f.async.fib
    end
    actors.map(&:result)
  end
end
