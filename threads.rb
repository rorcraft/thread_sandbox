require 'rubygems'
require 'bundler/setup'
require 'benchmark'

require 'mysql2'
require 'active_record'

puts "mysql2"
db = Mysql2::Client.new(:host => "localhost", :username => "root")

Benchmark.bm do |b|
  b.report("async") do
    db.query("SELECT sleep(1)", :async => true)
  end
  db.async_result
  b.report("sync") do
    db.query("SELECT sleep(1)")
  end
end

puts "activerecord"
ActiveRecord::Base.establish_connection(adapter: :mysql2, host: "localhost", username: "root")

Benchmark.bm do |b|
  b.report("sync") do
    ActiveRecord::Base.connection.execute("SELECT sleep(3)")
  end

  b.report("1 thread") do
    Thread.new do
      ActiveRecord::Base.connection.execute("SELECT sleep(3)")
    end
  end

  b.report("5 threads  db") do
    threads = []
    5.times do
      threads << Thread.new do
        ActiveRecord::Base.connection.execute("SELECT sleep(3)")
        ActiveRecord::Base.connection.close
      end
    end
    threads.map(&:join)
  end

  b.report("25m run") do
    25_000_000.times { 2+2 }
  end


  b.report("5 threads run") do
    threads = []
    5.times do
      threads << Thread.new do
        5_000_000.times { 2+2 }
      end
    end
    threads.map(&:join)
  end
end


