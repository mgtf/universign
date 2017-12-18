# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'universign/version'

Gem::Specification.new do |spec|
  spec.name          = 'universign'
  spec.version       = Universign::VERSION
  spec.authors       = ['Matthieu Foillard']
  spec.email         = ['mgf@iotanet.net']

  spec.summary       = %q{A ruby client for the Universign XML-RPC api}
  spec.description = <<-EOF
  A ruby client for the Universign XML-RPC api.
  Based on Universign documentation Version: 7.12.1
  EOF
  spec.homepage      = 'https://www.github.com/mgtf/universign'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.52.0'
  spec.required_ruby_version = '~> 2.0'
end
