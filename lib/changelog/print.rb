require 'thor'
require 'yaml'
require 'semantic'

module Changelog
  class Print < Thor
    include Thor::Actions

    no_commands do
      def go
        remove_file 'CHANGELOG.md'
        add_file 'CHANGELOG.md'

        append_to_file 'CHANGELOG.md', "# Changelog\n\n", verbose: false

        shell.say_status :append, "changes in changelog/unreleased", :green unless shell.mute?
        append_to_file 'CHANGELOG.md', "## [Unreleased]\n", verbose: false
        print_changes 'unreleased'

        version_folders.each do |version|
          shell.say_status :append, "changes in changelog/#{version}", :green unless shell.mute?
          print_version_header version
          print_changes version
        end
      end

      def print_version_header(folder)
        append_to_file 'CHANGELOG.md', "\n", verbose: false, force: true

        meta = YAML.load_file(File.join(destination_root, "changelog/#{folder}/tag.yml"))
        date = meta['date'].to_s
        append_to_file 'CHANGELOG.md', "## [#{folder}] - #{date}\n", verbose: false
      end

      def print_changes(folder)
        items = {}
        changelog_files(folder).each do |file|
          yaml = YAML.load_file(file)
          items[yaml['type']] ||= []
          items[yaml['type']] << "#{yaml['title'].strip} (@#{yaml['author']})"
        end

        sections = []
        Changelog.natures.each.with_index do |nature, i|
          if changes = items[nature].presence
            lines = []
            lines << "### #{nature}\n"
            changes.each do |change|
              lines << "- #{change}\n"
            end
            sections << lines.join
          end
        end

        append_to_file 'CHANGELOG.md', sections.join("\n"), verbose: false, force: true
      end

      def version_folders
        (Dir[File.join(destination_root, 'changelog/*')] - [
          File.join(destination_root, "changelog/unreleased")
        ]).collect {|path| File.basename(path)}.sort_by {|version| Semantic::Version.new(version)}.reverse
      end

      def changelog_files(folder)
        Dir[File.join(destination_root, "changelog/#{folder}/*.yml")] - [
          File.join(destination_root, "changelog/#{folder}/tag.yml")
        ]
      end
    end
  end
end
