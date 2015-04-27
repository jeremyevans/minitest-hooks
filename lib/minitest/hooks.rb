require 'minitest/spec'

# Add support for around and before_all/after_all/around_all hooks to
# minitest spec classes.
module Minitest::Hooks
  # Add the class methods to the class. Also, include an additional
  # module in the class that before(:all) and after(:all) methods
  # work on a class that directly includes this module.
  def self.included(mod)
    super
    mod.instance_exec do
      include(@hooks_module ||= Module.new)
      extend(Minitest::Hooks::ClassMethods)
    end
  end

  # Empty method, necessary so that super calls in spec subclasses work.
  def before_all
  end

  # Empty method, necessary so that super calls in spec subclasses work.
  def after_all
  end

  # Method that just yields, so that super calls in spec subclasses work.
  def around_all
    yield
  end

  # Method that just yields, so that super calls in spec subclasses work.
  def around
    yield
  end

  # Run around hook inside, since time_it is run around every spec.
  def time_it
    super do
      around do
        yield
      end
    end
  end
end

module Minitest::Hooks::ClassMethods
  # Object used to get an empty new instance, as new by default will return
  # a dup of the singleton instance.
  NEW = Object.new.freeze

  # Unless name is NEW, return a dup singleton instance.
  def new(name)
    if name.equal?(NEW)
      return super
    end

    instance = @instance.dup
    instance.name = name
    instance.failures = []
    instance
  end

  # When running the specs in the class, first create a singleton instance, the singleton is
  # used to implement around_all/before_all/after_all hooks, and each spec will run as a
  # dup of the singleton instance.
  def run(reporter, options={})
    r = nil
    @instance = new(NEW)

    @instance.around_all do
      @instance.before_all
      r = super
      @instance.after_all
    end
    r
  end

  # If type is :all, set the before_all hook instead of the before hook.
  def before(type=nil, &block)
    if type == :all
      (defined?(@hooks_module) ? @hooks_module : self).send(:define_method, :before_all) do
        super()
        instance_exec(&block)
      end
      nil
    else
      super
    end
  end

  # If type is :all, set the after_all hook instead of the after hook.
  def after(type=nil, &block)
    if type == :all
      (defined?(@hooks_module) ? @hooks_module : self).send(:define_method, :after_all) do
        instance_exec(&block)
        super()
      end
      nil
    else
      super
    end
  end
end

# Spec subclass that includes the hook methods.
class Minitest::HooksSpec < Minitest::Spec
  include Minitest::Hooks
end
