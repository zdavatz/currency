# -*- ruby -*-
lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'rake/testtask'
require 'rake/clean'
require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'currency/version'

task :default => [:clobber, :spec, :install]

task :spec => :clean
CLEAN.include FileList['pkg/*.gem']

# rspec
RSpec::Core::RakeTask.new(:spec)
