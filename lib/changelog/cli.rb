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

    desc 'add ITEM', 'Add a new changelog item'
    method_option :nature,
      type: :string,
      desc: 'Type of changes',
      default: '',
      enum: Changelog.natures,
      aliases: %w(--type -t)
    method_option :author,
      type: :string,
      desc: 'User who makes the changes',
      default: '',
      aliases: %w(--user -u)
    def add(title)
      Changelog::Add.new.go(title, options[:nature], options[:author])
    end
  end
end
