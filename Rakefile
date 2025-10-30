#!/usr/bin/env rake
require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/picturehouse_uk'
  t.test_files = FileList[
    'test/lib/picturehouse_uk/*_test.rb',
    'test/lib/picturehouse_uk/internal/*_test.rb',
    'test/lib/picturehouse_uk/internal/parser/*_test.rb'
  ]
  t.verbose = true
end

Rake::TestTask.new do |t|
  t.libs << 'lib/picturehouse_uk'
  t.name = :live
  t.test_files = FileList[
    'test/live/*_test.rb'
  ]
  t.verbose = true
end

# http://erniemiller.org/2014/02/05/7-lines-every-gems-rakefile-should-have/
task :console do
  require 'irb'
  require 'irb/completion'
  require 'picturehouse_uk'
  ARGV.clear
  IRB.start
end

desc 'recreate test fixtures'
task :fixtures do
  require 'picturehouse_uk'
  require_relative 'rake/fixture_creator'

  FixtureCreator.new.home
  %w(duke-of-york-s-picturehouse duke-s-at-komedia phoenix-picturehouse).each do |cinema_id|
    FixtureCreator.new.cinema(cinema_id)
  end
end

task default: :test
