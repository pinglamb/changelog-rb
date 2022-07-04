require_relative "lib/changelog/version.rb"

Gem::Specification.new do |spec|
  spec.name          = "changelog-rb"
  spec.version       = Changelog::VERSION
  spec.authors       = ["pinglamb"]
  spec.email         = ["pinglambs@gmail.com"]

  spec.summary       = %q{Make developers happy with http://keepachangelog.com/.}
  spec.homepage      = "https://github.com/pinglamb/changelog-rb"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/pinglamb/changelog-rb"
  spec.metadata["changelog_uri"]     = "https://github.com/pinglamb/changelog-rb/blob/master/CHANGELOG.md"

  spec.files = ["changelog-rb.gemspec", "README.md", "CHANGELOG.md", "LICENSE.txt"] + `git ls-files | grep -E '^(bin|lib)'`.split("\n")

  spec.executables   = ["changelog"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 1.2.1"
  spec.add_runtime_dependency "activesupport", "<= 5.2.8"
  spec.add_runtime_dependency "semantic", "~> 1.6.1"

  spec.add_development_dependency "bundler", "~> 2.3.14"
  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "rspec", "~> 3.11.0"
  spec.add_development_dependency "pry", "~> 0.14.1"
  spec.add_development_dependency "rubocop", "~> 1.31.1"
  spec.add_development_dependency "flog", "~> 4.6", ">= 4.6.5"
  spec.add_development_dependency 'flay', '~> 2.13'
end
