
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "changelog/version"

Gem::Specification.new do |spec|
  spec.name          = "changelog-rb"
  spec.version       = Changelog::VERSION
  spec.authors       = ["pinglamb"]
  spec.email         = ["pinglambs@gmail.com"]

  spec.summary       = %q{Make developers happy with http://keepachangelog.com/.}
  spec.homepage      = "https://github.com/pinglamb/changelog-rb"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.6")

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 1.2.1"
  spec.add_runtime_dependency "activesupport", "<= 5.2.8"
  spec.add_runtime_dependency "minitest", "<= 5.11.1"
  spec.add_runtime_dependency "semantic", "~> 1.6.1"

  spec.add_development_dependency "bundler", "~> 2.3.14"
  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "rspec", "~> 3.11.0"
  spec.add_development_dependency "fakefs", "~> 1.7.0"
  spec.add_development_dependency "pry", "~> 0.14.1"
end
