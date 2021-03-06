# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "authorizable/version"

Gem::Specification.new do |s|
  s.name        = "authorizable"
  s.version     = Authorizable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ["L. Preston Sego III", "Ryan Bates"]
  s.email       = "LPSego3+dev@gmail.com"
  s.homepage    = "https://github.com/NullVoxPopuli/authorizable"
  s.summary     = "Authorizable-#{Authorizable::VERSION}"
  s.description = "A gem for rails giving vast flexibility in authorization management."


  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.0'

  s.add_runtime_dependency "activesupport", ">= 3.0.0"
  s.add_runtime_dependency "i18n"

  # for testing a gem with a rails app (controller specs)
  # https://codingdaily.wordpress.com/2011/01/14/test-a-gem-with-the-rails-3-stack/
  s.add_development_dependency "bundler"
  s.add_development_dependency "rails", ">= 4"
  s.add_development_dependency "factory_girl_rails", "~> 4.4"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "codeclimate-test-reporter"

end
