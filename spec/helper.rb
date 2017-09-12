$:.unshift(File.join(File.dirname(File.expand_path(__FILE__)), "../lib/"))
require 'rubygems'
require 'sequel'
gem 'minitest'
require 'minitest/autorun'
DATABASE_URL = ENV['DATABASE_URL'] || (defined?(JRUBY_VERSION) ? 'jdbc:sqlite::memory:' : 'sqlite:/')
