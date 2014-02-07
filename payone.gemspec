# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'payone/version'

Gem::Specification.new do |spec|
  spec.name          = "payone"
  spec.version       = Payone::VERSION
  spec.authors       = 'ashamra-ror'
  spec.email         = 'asharma.ror@gmail.com'
  spec.description   = 'Provide credit card payment facility'
  spec.summary       = 'Provide credit card payment facility'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  # Add dependency
  spec.add_dependency('ruby', '>= 2.0.0')
  spec.add_dependency('rails', '>= 4.0.0')
  spec.add_dependency('spree_core',  '>= 2.0.0')
end
