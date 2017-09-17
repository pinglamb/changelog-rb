require 'active_support'
require 'active_support/core_ext'

require "changelog/version"

module Changelog
  def self.natures
    ['Added', 'Changed', 'Deprecated', 'Removed', 'Fixed', 'Security'].freeze
  end
end

require "changelog/setup"
require "changelog/add"
require "changelog/tag"
require "changelog/print"
