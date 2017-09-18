require 'active_support'
require 'active_support/core_ext'

require "changelog/version"

module Changelog
  def self.natures
    ['Added', 'Changed', 'Deprecated', 'Removed', 'Fixed', 'Security'].freeze
  end

  def self.dictionary
    {
      'Added'      => %w[add added new],
      'Changed'    => %w[change changed update updated make made],
      'Deprecated' => %w[deprecate deprecated],
      'Removed'    => %w[remove removed delete deleted],
      'Fixed'      => %w[fix fixed resolve resolved],
      'Security'   => %w[security protect],
    }
  end
end

require "changelog/setup"
require "changelog/add"
require "changelog/tag"
require "changelog/untag"
require "changelog/show"
require "changelog/print"
