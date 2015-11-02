# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spree_fosdick_integration/version'

Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.name          = "spree_fosdick_integration"
  spec.version       = SpreeFosdickIntegration::VERSION
  spec.authors       = ["anatolii-volodko"]
  spec.summary       = 'Integration Spree Commerce with Fosdick API'
  spec.description   = 'Integration Spree Commerce with Fosdick API (full service fulfillment services)'
  spec.email         = 'info@jetruby.com'
  spec.homepage      = 'http://jetruby.com/'
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'spree_core', '~> 2.4.3'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.3'
end
