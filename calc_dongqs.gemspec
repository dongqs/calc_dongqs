# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'calc_dongqs/version'

Gem::Specification.new do |spec|
  spec.name          = "calc_dongqs"
  spec.version       = CalcDongqs::VERSION
  spec.authors       = ["Dong Qingshan"]
  spec.email         = ["dongqs@gmail.com"]
  spec.summary       = %q{Simple Calculator}
  spec.description   = %q{Simple calculator without nagative number support}
  spec.homepage      = "http://github.com/dongqs/calc_dongqs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "guard-rspec", "~> 4.5"
end
