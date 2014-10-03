#!/usr/bin/env rake
require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/picturehouse_uk'
  t.test_files = FileList[
    'test/lib/picturehouse_uk/*_test.rb',
    'test/lib/picturehouse_uk/internal/*_test.rb'
  ]
  t.verbose = true
end

task :build do
  system "gem build picturehouse_uk.gemspec"
end

task :release => :build do
  system "gem push picturehouse_uk-#{PicturehouseUk::VERSION}"
end

task default: :test
