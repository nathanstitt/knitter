# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knitter/version'

Gem::Specification.new do |spec|
    spec.name          = "knitter"
    spec.version       = Knitter::VERSION
    spec.authors       = ["Nathan Stitt"]
    spec.email         = ["nathan@stitt.org"]

    spec.summary       = %q{Wraps the Javascript "yarn" package manager command}
    spec.description   = %q{Wraps the Javascript "yarn" command; query and install Javascript packages from Ruby.  Reads the package.json file directly to detect packages that are installed, and shells out to `yarn` to initialize and install packages.}
    spec.homepage      = "https://github.com/nathanstitt/knitter"
    spec.license       = "MIT"

    if spec.respond_to?(:metadata)
        spec.metadata['allowed_push_host'] = "https://rubygems.org"
    else
        raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
    end

    spec.files = `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
    end
    spec.bindir        = "exe"
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ["lib"]

    spec.add_dependency 'mixlib-shellout', '~> 2.2'

    spec.add_development_dependency "bundler",        "~> 1.13"
    spec.add_development_dependency "rake",           "~> 10.0"
    spec.add_development_dependency "guard",          "~> 2.13"
    spec.add_development_dependency "spy",            "~> 0.4.5"
    spec.add_development_dependency "guard-minitest", "~> 2.3"
end
