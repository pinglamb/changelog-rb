# frozen_string_literal: true
require "active_support"
require "active_support/core_ext"

require "changelog/version"
require "changelog/setup"
require "changelog/add"
require "changelog/tag"
require "changelog/untag"
require "changelog/show"
require "changelog/print"

module Changelog
  def self.natures
    ["Added", "Changed", "Deprecated", "Removed", "Fixed", "Security"].freeze
  end

  def self.dictionary
    {
      "Added"      => %w[add added new],
      "Changed"    => %w[change changed update updated make made],
      "Deprecated" => %w[deprecate deprecated],
      "Removed"    => %w[remove removed delete deleted],
      "Fixed"      => %w[fix fixed resolve resolved],
      "Security"   => %w[security protect],
    }
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end

  class Configuration
    attr_accessor :versions_path
    attr_accessor :summary_path
  end
end

# temp solution for issue: https://bugs.ruby-lang.org/issues/17866
# [Workaround with fbb4e3f96c10de2240f2d87eac19cf6f62f65fea](https://github.com/ruby/ruby/commit/d8fd92f62024d85271a3f1125bc6928409f912e1)
module WorkaroundYAML
  def self.load_file(filename)
    if RUBY_VERSION =~ /3.1/
      YAML.unsafe_load_file(filename)
    else
      YAML.load_file(filename)
    end
  end
end

Changelog.configure do |config|
  config.versions_path = "changelog"
  config.summary_path = "CHANGELOG.md"
end
