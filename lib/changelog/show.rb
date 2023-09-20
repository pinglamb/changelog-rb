require 'thor'
require 'yaml'
require 'changelog/helpers/changes'

module Changelog
  class Show < Thor
    include Thor::Actions

    no_commands do
      include Changelog::Helpers::Changes

      def go(version = nil)
        versions =
          if version
            versions = [version]
          else
            %w[unreleased].push(version_folders.first)
          end

        versions.each { |version| print_version(version) }
      end

      private

      def print_version(version)
        if File.exist?(File.join(destination_root, "changelog/#{version}"))
          puts version_header(version)
          puts read_changes(version)
        else
          puts "changelog/#{version} not found"
        end
      end
    end
  end
end
