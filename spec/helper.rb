$:.unshift(File.join(File.dirname(File.expand_path(__FILE__)), "../lib/"))
require 'rubygems'
require 'sequel'
ENV['MT_NO_PLUGINS'] = '1' # Work around stupid autoloading of plugins
gem 'minitest'
require 'minitest/global_expectations/autorun'
DATABASE_URL = ENV['DATABASE_URL'] || (defined?(JRUBY_VERSION) ? 'jdbc:sqlite::memory:' : 'sqlite:/')
