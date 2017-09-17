require 'thor'
require 'yaml'
require 'changelog/helpers/changes'

module Changelog
  class Show < Thor
    include Thor::Actions

    no_commands do
      include Changelog::Helpers::Changes

      def go(version)
        if File.exists?(File.join(destination_root, "changelog/#{version}"))
          puts version_header(version)
          puts read_changes(version)
        else
          say "changelog/#{version} not found"
        end
      end
    end
  end
end
