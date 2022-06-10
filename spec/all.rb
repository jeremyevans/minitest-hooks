require 'rbconfig'
ENV['RUBY'] ||= ENV["RUBY"] || File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"] + RbConfig::CONFIG["EXEEXT"]).sub(/.*\s.*/m, '"\&"')
ENV['RUBYLIB'] = "lib:#{ENV['RUBYLIB']}"
Dir['./spec/*_{spec,test}.rb'].each{|f| require f}
