require 'minitest/hooks'
require 'minitest/spec'

# Spec subclass that includes the hook methods.
class Minitest::HooksSpec < Minitest::Spec
  include Minitest::Hooks
end

MiniTest::Spec.register_spec_type(//, Minitest::HooksSpec)
