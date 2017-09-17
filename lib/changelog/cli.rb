require 'thor'
require 'changelog-rb'

module Changelog
  class CLI < Thor
    include Thor::Actions

    package_name 'changelog'

    desc 'version', 'Show current version'
    def version
      say Changelog::VERSION
    end

    desc 'setup', 'Bootstrap changelog'
    def setup
      Changelog::Setup.new.go
    end

    desc 'add [ITEM]', 'Add a new changelog item'
    method_option :nature,
      type: :string,
      desc: 'Type of changes',
      lazy_default: '',
      enum: Changelog.natures,
      aliases: %w(--type -t)
    method_option :author,
      type: :string,
      desc: 'User who makes the changes',
      lazy_default: '',
      aliases: %w(--user -u)
    method_option :git,
      type: :string,
      desc: 'Extracts the title from git commit comment',
      lazy_default: '',
      aliases: %w(-g)
    def add(title = '')
      Changelog::Add.new.go(title, options.symbolize_keys)
    end

    desc 'tag VERSION', 'Tag the unreleased changes to a version'
    def tag(version)
      Changelog::Tag.new.go(version)
    end

    desc 'print', 'Print ./changelog to CHANGELOG.md'
    def print
      Changelog::Print.new.go
    end
  end
end
