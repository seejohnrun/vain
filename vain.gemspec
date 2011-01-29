require 'rubygems'
require File.dirname(__FILE__) + '/lib/vain/version'

spec = Gem::Specification.new do |s|

  s.name = 'vain'
  s.author = 'John Crepezzi'
  s.add_dependency('columnizer',  '0.0.3')
  s.add_dependency('rest-client', '~> 1.6')
  s.add_dependency('json_pure',        '~> 1.4.6')
  s.add_dependency('hashie',      '~> 1.0')
  s.description = 'View information about a GitHub account'
  s.email = 'john@crepezzi.com'
  s.executables = 'vain'
  s.files = Dir['lib/**/*.rb']
  s.has_rdoc = true
  s.homepage = 'http://github.com/seejohnrun/vain/'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.summary = 'GitHub account info'
  s.test_files = Dir.glob('spec/*.rb')
  s.version = Vain::version
  s.rubyforge_project = "vain"

end
