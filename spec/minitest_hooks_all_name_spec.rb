require './spec/helper'
require 'minitest/hooks/default'

describe 'Minitest::Hooks error handling' do
  before(:all) do
    name.must_equal :before_all
  end
  after(:all) do
    name.must_equal :after_all
  end
  around do |&block|
  end
  around(:all) do |&block|
    name.must_equal :around_all
    super(&block)
    name.must_equal :around_all
  end

  3.times do |i|
    it "should work try #{i}" do
    end
  end
end
