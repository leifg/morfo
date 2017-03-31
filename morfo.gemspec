# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "morfo/version"

Gem::Specification.new do |spec|
  spec.name          = "morfo"
  spec.version       = Morfo::VERSION
  spec.authors       = ["Leif Gensert"]
  spec.email         = ["leif@propertybase.com"]
  spec.description   = %q{This gem provides a DSL for converting one hash into another}
  spec.summary       = %q{Inspired by ActiveImporter, this gem generically converts an array of hashes}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features|benchmarks)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "deep_merge"
  spec.add_runtime_dependency "rubysl" if RUBY_ENGINE == "rbx"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler", "~> 1.3"
end
