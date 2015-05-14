Gem::Specification.new do |s|
  s.name = 'minitest-hooks'
  s.version = '1.1.0'
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG", "MIT-LICENSE"]
  s.rdoc_options += ["--quiet", "--line-numbers", "--inline-source", '--title', 'minitest-hooks: around and before_all/after_all/around_all hooks for Minitest', '--main', 'README.rdoc']
  s.license = "MIT"
  s.summary = "Around and before_all/after_all/around_all hooks for Minitest"
  s.author = "Jeremy Evans"
  s.email = "code@jeremyevans.net"
  s.homepage = "http://github.com/jeremyevans/minitest-hooks"
  s.files = %w(MIT-LICENSE CHANGELOG README.rdoc Rakefile) + Dir["{spec,lib}/**/*.rb"]
  s.description = <<END
minitest-hooks adds around and before_all/after_all/around_all hooks for Minitest.
This allows you do things like run each suite of specs inside a database transaction,
running each spec inside its own savepoint inside that transaction, which can
significantly speed up testing for specs that share expensive database setup code.
END

  s.add_development_dependency "minitest", '>5'
  s.add_development_dependency "sequel", '>4'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake"
end
