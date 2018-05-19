require './spec/helper'
require 'minitest/hooks/default'

error = ENV['MINITEST_HOOKS_ERRORS']

module Minitest
  def self.plugin_result_inspector_reporter_init(options)
    self.reporter << ResultInspectorReporter.new(options[:io], options)
  end

  class ResultInspectorReporter < SummaryReporter
    def report
      results.each do |result|
        io.puts "result to_s: #{result.to_s.inspect}"
        # For MiniTest 5.11+, we expect Minitest::Result objects.
        if defined?(Minitest::Result)
          io.puts "result source_location: #{result.source_location.inspect}"
        else
          # For older versions of Minitest, extract source_location in a
          # similar fashion to how some third party reporters expected to be
          # able to:
          # https://github.com/circleci/minitest-ci/blob/8b72b0f32f154d91b53d63d1d0a8a8fb3b01d726/lib/minitest/ci_plugin.rb#L139
          io.puts "result source_location: #{result.method(result.name).source_location.inspect}"
        end
      end
    end
  end
end

Minitest.extensions << "result_inspector_reporter"

describe 'Minitest::Hooks error handling' do
  before(:all) do
    raise if error == 'before-all'
  end
  before do
    raise if error == 'before'
  end
  after do
    raise if error == 'after'
  end
  after(:all) do
    raise if error == 'after-all'
  end
  around do |&block|
    raise if error == 'around-before'
    super(&block)
    raise if error == 'around-after'
  end
  around(:all) do |&block|
    raise if error == 'around-all-before'
    super(&block)
    case error
    when 'before-all'
      name.must_equal 'before_all'
    when 'after-all'
      name.must_equal 'after_all'
    else
      name.must_equal 'around_all'
    end
    raise if error == 'around-all-after'
  end

  3.times do |i|
    it "should work try #{i}" do
    end
  end
end
