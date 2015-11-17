require './spec/helper'
require 'minitest/hooks/default'

error = ENV['MINITEST_HOOKS_ERRORS']

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
    raise if error == 'around-all-after'
  end

  3.times do |i|
    it "should work try #{i}" do
    end
  end
end
