require 'rubygems'
require 'bundler/setup'
require 'benchmark'

require 'em-synchrony'
require 'mysql2'
require 'em-synchrony/fiber_iterator'
require 'em-synchrony/activerecord'

require 'pry'

puts "em-synchrony/activerecord"

ActiveRecord::Base.establish_connection(adapter: "em_mysql2", host: "localhost", username: "root", pool: 10)
Benchmark.bm do |b|
  b.report("1 select") do
    result = []
    EM.synchrony do
      result << ActiveRecord::Base.connection.execute("SELECT sleep(3)")
      EM.stop
    end
    # puts result
  end

  b.report("5 Fibers db") do
    fibers = []
    result = []
    EM.synchrony do
      # EM::Synchrony::Iterator.new(1..5).each do
      5.times do
        result << Fiber.new do
          ActiveRecord::Base.connection.execute("SELECT sleep(3)")
          # sleep(3)
        end.resume
      end
      EM.stop
    end
    puts result
  end

  b.report("5 concurrent") do
    result = []
    concurrent = 5
    EM.synchrony do
      EM::Synchrony::FiberIterator.new(1..5, concurrent).each do
        result << ActiveRecord::Base.connection.execute("SELECT sleep(3)")
      end
      EM.stop
    end
    # puts result
  end

end


