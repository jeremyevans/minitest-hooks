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
  sh %{#{FileUtils::RUBY} #{"-w" if RUBY_VERSION >= '3'} #{'-W:strict_unused_block' if RUBY_VERSION >= '3.4'} spec/all.rb}
end

desc "Run specs with coverage"
task :spec_cov do
  ENV['COVERAGE'] = '1'
  sh %{#{FileUtils::RUBY} spec/all.rb}
end

task :default=>:spec

### RDoc

RDOC_DEFAULT_OPTS = ["--quiet", "--line-numbers", "--inline-source", '--title', 'minitest-hooks: around and before_all/after_all/around_all hooks for Minitest']

begin
  gem 'hanna'
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

