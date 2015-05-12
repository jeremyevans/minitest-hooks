require "rake"
require "rake/clean"

CLEAN.include ["minitest-hooks-*.gem", "rdoc", "coverage"]

desc "Build minitest-hooks gem"
task :package=>[:clean] do |p|
  sh %{#{FileUtils::RUBY} -S gem build minitest-hooks.gemspec}
end

### Specs

desc "Run specs"
task :spec do
  sh %{#{FileUtils::RUBY} -I lib -e 'ARGV.each{|f| require f}' ./spec/*.rb}
end

task :default=>:spec

### RDoc

RDOC_DEFAULT_OPTS = ["--quiet", "--line-numbers", "--inline-source", '--title', 'minitest-hooks: around and before_all/after_all/around_all hooks for Minitest']

begin
  gem 'hanna-nouveau'
  RDOC_DEFAULT_OPTS.concat(['-f', 'hanna'])
rescue Gem::LoadError
end

rdoc_task_class = begin
  require "rdoc/task"
  RDoc::Task
rescue LoadError
  require "rake/rdoctask"
  Rake::RDocTask
end

RDOC_OPTS = RDOC_DEFAULT_OPTS + ['--main', 'README.rdoc']

rdoc_task_class.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.options += RDOC_OPTS
  rdoc.rdoc_files.add %w"README.rdoc CHANGELOG MIT-LICENSE lib/**/*.rb"
end

# Features
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)
