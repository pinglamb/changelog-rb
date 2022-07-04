# frozen_string_literal: true
require "thor"
require "yaml"
require "semantic"
require "changelog/helpers/git"
require "changelog/helpers/changes"

module Changelog
  class Print < Thor
    include Thor::Actions

    no_commands do
      include Changelog::Helpers::Changes

      def go
        remove_file Changelog.configuration.summary_path
        add_file Changelog.configuration.summary_path

        append_to_file Changelog.configuration.summary_path, "# Changelog\n", verbose: false

        versions = %w[unreleased].concat(version_folders)

        versions.each do |version|
          shell.say_status :append, "changes in #{Changelog.configuration.versions_path}/#{version}", :green unless shell.mute?
          print_version_header version
          print_changes version
        end

        if Changelog::Helpers::Git.github_url.present?
          append_to_file Changelog.configuration.summary_path, "\n", verbose: false, force: true
          versions.each_cons(2) do |v1, v2|
            append_to_file Changelog.configuration.summary_path, "[#{version_text(v1)}]: #{Changelog::Helpers::Git.compare_url(version_sha(v2), version_sha(v1))}\n", verbose: false
          end
        end
      end

      def print_version_header(folder)
        append_to_file Changelog.configuration.summary_path, "\n", verbose: false, force: true
        append_to_file Changelog.configuration.summary_path, version_header(folder), verbose: false
      end

      def print_changes(folder)
        append_to_file Changelog.configuration.summary_path, read_changes(folder), verbose: false, force: true
      end
    end
  end
end
