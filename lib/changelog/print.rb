require 'thor'
require 'yaml'
require 'semantic'
require 'changelog/helpers/git'
require 'changelog/helpers/changes'

module Changelog
  class Print < Thor
    include Thor::Actions

    no_commands do
      include Changelog::Helpers::Changes

      def go
        remove_file 'CHANGELOG.md'
        add_file 'CHANGELOG.md'

        append_to_file 'CHANGELOG.md', "# Changelog\n", verbose: false

        versions = %w[unreleased].concat(version_folders)

        versions.each do |version|
          shell.say_status :append, "changes in changelog/#{version}", :green unless shell.mute?
          print_version_header version
          print_changes version
        end

        if Changelog::Helpers::Git.github_url.present?
          append_to_file 'CHANGELOG.md', "\n", verbose: false, force: true
          versions.each_cons(2) do |v1, v2|
            append_to_file 'CHANGELOG.md', "[#{version_text(v1)}]: #{Changelog::Helpers::Git.compare_url(version_sha(v2), version_sha(v1))}\n", verbose: false
          end
        end
      end

      def print_version_header(folder)
        append_to_file 'CHANGELOG.md', "\n", verbose: false, force: true
        append_to_file 'CHANGELOG.md', version_header(folder), verbose: false
      end

      def print_changes(folder)
        append_to_file 'CHANGELOG.md', read_changes(folder), verbose: false, force: true
      end

      def version_folders
        (Dir[File.join(destination_root, 'changelog/*')] - [
          File.join(destination_root, "changelog/unreleased")
        ]).collect {|path| File.basename(path)}.sort_by {|version|
          if version.match Semantic::Version::SemVerRegexp
            Semantic::Version.new(version)
          elsif version.match /\A(0|[1-9]\d*)\.(0|[1-9]\d*)\Z/
            # Example: 0.3, 1.5, convert it to 0.3.0, 1.5.0
            Semantic::Version.new("#{version}.0")
          end
        }.reverse
      end
    end
  end
end
