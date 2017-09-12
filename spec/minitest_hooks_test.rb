require './spec/helper'
require 'minitest/hooks/test'

class MyTest < Minitest::Test
  include Minitest::Hooks
end

class TestMinitestHooks < MyTest
  DB = Sequel.connect(DATABASE_URL)

  def before_all
    super
    @ds_ba = @ds_aa
    assert_equal @ds_ba.count, 1 + @i
  end
  def setup
    super
    @ds_be = @ds_ae
    assert_equal @ds_be.count, 2 + @i * 2
  end
  def teardown
    assert_equal @ds_be.count, 2 + @i * 2
    super
  end
  def after_all
    assert_equal @ds_ba.count, 1 + @i
    super
  end
  def around
    assert_equal @ds_aa.count, 1 + @i
    DB.transaction(:rollback=>:always, :savepoint=>true, :auto_savepoint=>true) do
      @ds_ae = @ds_aa
      @ds_ae.insert(1)
      super
    end
    assert_equal @ds_aa.count, 1 + @i
  end
  def around_all
    @i ||= 0
    DB.transaction(:rollback=>:always) do
      DB.create_table(:a){Integer :a}
      @ds_aa = DB[:a]
      assert_equal @ds_aa.count, 0
      @ds_aa.insert(1)
      super
    end
    assert_equal DB.table_exists?(:a), false
  end

  3.times do |i|
    define_method(:"test_should_work_#{i}") do
      assert_equal @ds_aa.count, 2
      assert_equal @ds_ae.count, 2
      assert_equal @ds_ba.count, 2
      assert_equal @ds_be.count, 2
    end
  end

  class TestMinitestHooks2 < self
    def before_all
      super
      @ds_ba3 = @ds_ba
      @ds_ba2 = @ds_aa2
      assert_equal @ds_ba2.count, 2
    end
    def setup
      super
      @ds_be3 = @ds_be
      @ds_be2 = @ds_ae2
      assert_equal @ds_be2.count, 4
    end
    def teardown
      assert_equal @ds_be2.count, 4
      super
    end
    def after_all
      assert_equal @ds_ba2.count, 2
      super
    end
    def around
      assert_equal @ds_aa.count, 2
      super do
        assert_equal @ds_aa.count, 3
        @ds_ae3 = @ds_ae
        @ds_ae2 = @ds_aa2
        @ds_ae2.insert(1)
        yield
        assert_equal @ds_aa.count, 4
      end
      assert_equal @ds_aa.count, 2
    end
    def around_all
      @i ||= 1
      super do
        assert_equal @ds_aa.count, 1
        @ds_aa2 = @ds_aa
        @ds_aa2.insert(1)
        yield
        assert_equal @ds_aa.count, 2
      end
      assert_equal DB.table_exists?(:a), false
    end

    3.times do |i|
      define_method(:"test_should_work_#{i}") do
        assert_equal @ds_aa.count, 4
        assert_equal @ds_ae.count, 4
        assert_equal @ds_ba.count, 4
        assert_equal @ds_be.count, 4
        assert_equal @ds_aa2.count, 4
        assert_equal @ds_ae2.count, 4
        assert_equal @ds_ba2.count, 4
        assert_equal @ds_be2.count, 4
        assert_equal @ds_ae3.count, 4
        assert_equal @ds_ba3.count, 4
        assert_equal @ds_be3.count, 4
      end
    end
  end
end
