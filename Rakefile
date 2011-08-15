require 'rake'
require 'rake/testtask'
require 'rubygems'
require 'rubygems/package_task'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test Rack::Staging'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

spec_data = File.open('rack_staging.gemspec').read
spec = nil
Thread.new do
  spec = eval("#{spec_data}")
end.join

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end
