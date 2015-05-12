require 'minitest/spec'

class MyWorld
  include Minitest::Assertions

  attr_accessor :assertions

  def initialize
    self.assertions = 0
    @temp_pathes = {}
  end

  def write_test_file(filename, content)
    # RSpec.describe -> describe
    content.gsub!("RSpec.describe", "describe")

    content.gsub!("|example|", "|&example|")
    content.gsub!("example.run", "super(&example)")
    # expect(..).to .. -> expect(..).must_equal ..
    content.gsub!("to eq", "must_equal")

    content = <<-RUBY + content
      require 'minitest/autorun'
      $LOAD_PATH << '#{File.expand_path("../../../lib", __FILE__)}'
      require 'minitest/hooks/default'
    RUBY
    write_file(filename, content)
  end

  def write_file(filename, content)
    Tempfile.open(filename) do |file|
      file.write content
      assoc_tempfile filename, file.path
    end
  end

  def path_for(filename)
    @temp_pathes.fetch(filename)
  end

  private

  def assoc_tempfile(filename, temp_path)
    @temp_pathes[filename] = temp_path
  end
end

World do
  MyWorld.new
end
