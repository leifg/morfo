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

  spec.add_dependency "rake"
  spec.add_dependency "json"
  spec.add_dependency "activesupport", ">= 3.2"
  spec.add_dependency "rubysl" if RUBY_ENGINE == "rbx"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", ">= 2.14", "< 4.0"
end
