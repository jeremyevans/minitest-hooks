require './spec/helper'
require 'minitest/hooks'

NDB = Sequel.connect(DATABASE_URL)

MiniTest::Spec.register_spec_type(/no_default/, Minitest::Spec)

describe 'Minitest::Hooks with transactions/savepoints no_default' do
  include Minitest::Hooks

  before(:all) do
    @ds_ba = @ds_aa
    @ds_ba.count.must_equal 1 + @i
  end
  before do
    @ds_be = @ds_ae
    @ds_be.count.must_equal 2 + @i * 2
  end
  after do
    @ds_be.count.must_equal 2 + @i * 2
  end
  after(:all) do
    @ds_ba.count.must_equal 1 + @i
  end
  around do |&block|
    @ds_aa.count.must_equal 1 + @i
    NDB.transaction(:rollback=>:always, :savepoint=>true, :auto_savepoint=>true) do
      @ds_ae = @ds_aa
      @ds_ae.insert(1)
      super(&block)
    end
    @ds_aa.count.must_equal 1 + @i
  end
  around(:all) do |&block|
    @i ||= 0
    NDB.transaction(:rollback=>:always) do
      NDB.create_table(:a){Integer :a}
      @ds_aa = NDB[:a]
      @ds_aa.count.must_equal 0
      @ds_aa.insert(1)
      super(&block)
    end
    NDB.table_exists?(:a).must_equal false
  end

  3.times do |i|
    it "should work try #{i}" do
      @ds_aa.count.must_equal 2
      @ds_ae.count.must_equal 2
      @ds_ba.count.must_equal 2
      @ds_be.count.must_equal 2
    end
  end

  describe "in nested describe" do
    before(:all) do
      @ds_ba3 = @ds_ba
      @ds_ba2 = @ds_aa2
      @ds_ba2.count.must_equal 2
    end
    before do
      @ds_be3 = @ds_be
      @ds_be2 = @ds_ae2
      @ds_be2.count.must_equal 4
    end
    after do
      @ds_be2.count.must_equal 4
    end
    after(:all) do
      @ds_ba2.count.must_equal 2
    end
    around do |&block|
      @ds_aa.count.must_equal 2
      super() do
        @ds_aa.count.must_equal 3
        @ds_ae3 = @ds_ae
        @ds_ae2 = @ds_aa2
        @ds_ae2.insert(1)
        block.call
        @ds_aa.count.must_equal 4
      end
      @ds_aa.count.must_equal 2
    end
    around(:all) do |&block|
      @i ||= 1
      super() do
        @ds_aa.count.must_equal 1
        @ds_aa2 = @ds_aa
        @ds_aa2.insert(1)
        block.call
        @ds_aa.count.must_equal 2
      end
      NDB.table_exists?(:a).must_equal false
    end

    3.times do |i|
      it "should work try #{i}" do
        @ds_aa.count.must_equal 4
        @ds_ae.count.must_equal 4
        @ds_ba.count.must_equal 4
        @ds_be.count.must_equal 4
        @ds_aa2.count.must_equal 4
        @ds_ae2.count.must_equal 4
        @ds_ba2.count.must_equal 4
        @ds_be2.count.must_equal 4
        @ds_ae3.count.must_equal 4
        @ds_ba3.count.must_equal 4
        @ds_be3.count.must_equal 4
      end
    end
  end
end

