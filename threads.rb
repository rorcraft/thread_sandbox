# require 'rubygems'
require 'bundler'

Bundler.require(:default)

# puts "mysql2"
# db = Mysql2::Client.new(:host => "localhost", :username => "root")

# Benchmark.bm do |b|
#   b.report("async") do
#     db.query("SELECT sleep(1)", :async => true)
#   end
#   db.async_result
#   b.report("sync") do
#     db.query("SELECT sleep(1)")
#   end
# end

adapter = RUBY_PLATFORM =~ /java/ ? 'mysql' : 'mysql2'

puts "activerecord"
ActiveRecord::Base.establish_connection(adapter: adapter,  password: "", host: "localhost", username: "root", pool: 5)

Benchmark.bm do |b|
  b.report("db sleep(3)") do
    ActiveRecord::Base.connection.execute("SELECT sleep(3)")
  end

  b.report("1 thread") do
    Thread.new do
      ActiveRecord::Base.connection.execute("SELECT sleep(3)")
    end.join
  end

  b.report("5 threads") do
    threads = []
    5.times do
      threads << Thread.new do
        ActiveRecord::Base.connection.execute("SELECT sleep(3)")
        ActiveRecord::Base.connection.close
      end
    end
    threads.map(&:join)
  end
end

puts "computation"

def fib(n)
  n < 2 ? n : fib(n-1) + fib(n-2)
end

Benchmark.bm do |b|

  b.report("fib(32)") do
    fib(32)
  end


  b.report("5 threads") do
    threads = []
    5.times do
      threads << Thread.new do
        fib(32)
      end
    end
    threads.map(&:join)
  end
end


