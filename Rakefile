require 'rake'
require 'rake/testtask'
require 'rubygems'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test Rack::Staging'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
