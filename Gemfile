# A sample Gemfile
source "https://rubygems.org"

gem 'pry'
gem 'activerecord' , "~> 3.2", require: "active_record"

platform 'ruby' do
  gem "mysql2"
end

platform 'jruby' do
  gem 'activerecord-jdbc-adapter', :github => 'jruby/activerecord-jdbc-adapter'
  gem 'activerecord-jdbcmysql-adapter', :github => 'jruby/activerecord-jdbc-adapter'
  gem 'jdbc-mysql', require: 'jdbc/mysql', :github => 'jruby/activerecord-jdbc-adapter'
end


group :evented do
  gem 'em-synchrony'
end

group :actor do
  gem 'celluloid'
end
