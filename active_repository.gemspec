# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_repository/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Caio Torres"]
  gem.email         = ["efreesen@gmail.com"]
  gem.description   = %q{An implementation of repository pattern that can connect with any ORM}
  gem.summary       = %q{An implementation of repository pattern that can connect with any ORM}
  gem.homepage      = "http://github.com/efreesen/active_repository"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "active_repository"
  gem.require_paths = ["lib"]
  gem.version       = ActiveRepository::VERSION
  gem.license       = "MIT"
  gem.files         = [
    "LICENSE",
    "README.md",
    "active_repository.gemspec",
    Dir.glob("lib/**/*")
  ].flatten
  gem.test_files = [
    "Gemfile",
    "spec/active_repository/base_spec.rb",
    "spec/active_repository/associations_spec.rb",
    "spec/active_repository/sql_query_executor_spec.rb",
    "spec/support/shared_examples.rb",
    "spec/support/sql_query_shared_examples.rb",
    "spec/spec_helper.rb"
  ]

  gem.add_runtime_dependency(%q<active_hash>, [">= 0.9.12"])
  gem.add_runtime_dependency(%q<activemodel>, [">= 3.2.6"])
  gem.add_development_dependency(%q<rspec>, [">= 2.2.0"])
  gem.add_development_dependency(%q<activerecord>, [">= 3.2.6"])
  gem.add_development_dependency(%q<mongoid>, [">= 3.0.11"])
  gem.add_development_dependency('rake', [">= 10.0.0"])
  gem.add_development_dependency(%q<sqlite3>) unless RUBY_PLATFORM == 'java'
  gem.add_development_dependency(%q<jdbc-sqlite3>)  if RUBY_PLATFORM == 'java'
  gem.add_development_dependency(%q<jruby-openssl>)  if RUBY_PLATFORM == 'java'
  gem.add_development_dependency(%q<activerecord-jdbcsqlite3-adapter>)  if RUBY_PLATFORM == 'java'
end
