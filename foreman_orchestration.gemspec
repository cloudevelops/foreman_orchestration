require File.expand_path('../lib/foreman_orchestration/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_orchestration'
  s.version     = ForemanOrchestration::VERSION
  s.date        = Date.today.to_s
  s.authors     = ['Zdenek Janda', 'Pavel Ivanov']
  s.email       = ['ivpavig@gmail.com']
  s.homepage    = 'https://github.com/cloudevelops/foreman_orchestration'
  s.summary     = 'Orchestration plugin for foreman'
  # also update locale/gemspec.rb
  s.description = 'Orchestration plugin for foreman'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
