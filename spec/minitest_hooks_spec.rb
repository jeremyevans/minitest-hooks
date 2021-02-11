require './spec/helper'
require 'minitest/hooks/default'

DB = Sequel.connect(DATABASE_URL)

describe 'Minitest::Hooks with transactions/savepoints' do
  before(:all) do
    @ds_ba = @ds_aa
    _(@ds_ba.count).must_equal 1 + @i
  end
  before do
    @ds_be = @ds_ae
    _(@ds_be.count).must_equal 2 + @i * 2
  end
  after do
    _(@ds_be.count).must_equal 2 + @i * 2
  end
  after(:all) do
    _(@ds_ba.count).must_equal 1 + @i
  end
  around do |&block|
    _(@ds_aa.count).must_equal 1 + @i
    DB.transaction(:rollback=>:always, :savepoint=>true, :auto_savepoint=>true) do
      @ds_ae = @ds_aa
      @ds_ae.insert(1)
      super(&block)
    end
    _(@ds_aa.count).must_equal 1 + @i
  end
  around(:all) do |&block|
    @i ||= 0
    DB.transaction(:rollback=>:always) do
      DB.create_table(:a){Integer :a}
      @ds_aa = DB[:a]
      _(@ds_aa.count).must_equal 0
      @ds_aa.insert(1)
      super(&block)
    end
    _(DB.table_exists?(:a)).must_equal false
  end

  3.times do |i|
    it "should work try #{i}" do
      _(@ds_aa.count).must_equal 2
      _(@ds_ae.count).must_equal 2
      _(@ds_ba.count).must_equal 2
      _(@ds_be.count).must_equal 2
    end
  end

  describe "in nested describe" do
    before(:all) do
      @ds_ba3 = @ds_ba
      @ds_ba2 = @ds_aa2
      _(@ds_ba2.count).must_equal 2
    end
    before do
      @ds_be3 = @ds_be
      @ds_be2 = @ds_ae2
      _(@ds_be2.count).must_equal 4
    end
    after do
      _(@ds_be2.count).must_equal 4
    end
    after(:all) do
      _(@ds_ba2.count).must_equal 2
    end
    around do |&block|
      _(@ds_aa.count).must_equal 2
      super() do
        _(@ds_aa.count).must_equal 3
        @ds_ae3 = @ds_ae
        @ds_ae2 = @ds_aa2
        @ds_ae2.insert(1)
        block.call
        _(@ds_aa.count).must_equal 4
      end
      _(@ds_aa.count).must_equal 2
    end
    around(:all) do |&block|
      @i ||= 1
      super() do
        _(@ds_aa.count).must_equal 1
        @ds_aa2 = @ds_aa
        @ds_aa2.insert(1)
        block.call
        _(@ds_aa.count).must_equal 2
      end
      _(DB.table_exists?(:a)).must_equal false
    end

    3.times do |i|
      it "should work try #{i}" do
        _(@ds_aa.count).must_equal 4
        _(@ds_ae.count).must_equal 4
        _(@ds_ba.count).must_equal 4
        _(@ds_be.count).must_equal 4
        _(@ds_aa2.count).must_equal 4
        _(@ds_ae2.count).must_equal 4
        _(@ds_ba2.count).must_equal 4
        _(@ds_be2.count).must_equal 4
        _(@ds_ae3.count).must_equal 4
        _(@ds_ba3.count).must_equal 4
        _(@ds_be3.count).must_equal 4
      end
    end
  end
end
