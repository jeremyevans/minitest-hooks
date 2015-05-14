require "bundler/gem_tasks"

require "rake/testtask"
Rake::TestTask.new :default do |test|
  test.test_files = ["spec/*_spec.rb"]
  test.verbose = true
end

spec = Gem::Specification.find_by_name("minitest-hooks")
require "rdoc/task"
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.options = spec.rdoc_options
  rdoc.rdoc_files.add spec.extra_rdoc_files
end

