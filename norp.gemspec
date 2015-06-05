# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'norp/version'

Gem::Specification.new do |spec|
  spec.name          = "norp"
  spec.version       = Norp::VERSION
  spec.authors       = ["JoshAshby"]
  spec.email         = ["joshuaashby@joshashby.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'awesome_print', '~> 1.6.1'
  spec.add_development_dependency 'byebug', '~> 5.0.0'
  spec.add_development_dependency 'yard', '~> 0.8.7.6'

  spec.add_runtime_dependency 'rugged', '~> 0.22.2'
end
