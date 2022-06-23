require 'thor'
require 'yaml'
require 'changelog/helpers/changes'

module Changelog
  class Show < Thor
    include Thor::Actions

    no_commands do
      include Changelog::Helpers::Changes

      def go(version = nil)
        versions = version.nil? ? default_shown_versions : Array[version]

        versions.each do |version|
          print_version(version)
        end
      end

      private

      def print_version(version)
        if File.exist?(File.join(destination_root, "changelog/#{version}"))
          say version_header(version)
          say read_changes(version)
        else
          say "changelog/#{version} not found"
        end
      end

      def default_shown_versions
        %w[unreleased].push(latest_version).compact
      end
    end
  end
end
