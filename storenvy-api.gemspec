# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'storenvy/version'

Gem::Specification.new do |spec|
  spec.name          = "storenvy-api"
  spec.version       = Storenvy::VERSION
  spec.authors       = ["Omri Cohen"]
  spec.email         = ["omri@yotpo.com"]
  spec.description   = %q{Ruby wrapper for Sotrenvy API - written by Yotpo}
  spec.summary       = %q{Ruby wrapper for Sotrenvy API - written by Yotpo}
  spec.homepage      = "https://developers.storenvy.com/docs"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_dependency "oauth2"
  spec.add_dependency 'faraday'
  spec.add_dependency 'typhoeus'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'faraday_middleware-parse_oj'
  spec.add_dependency 'hashie'
  spec.add_dependency 'activesupport'
end
