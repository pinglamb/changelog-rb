require 'thor'
require 'yaml'

module Changelog
  class Print < Thor
    include Thor::Actions

    no_commands do
      def go
        remove_file 'CHANGELOG.md'
        add_file 'CHANGELOG.md'

        append_to_file 'CHANGELOG.md', "# Changelog\n\n", verbose: false

        append_to_file 'CHANGELOG.md', "## [Unreleased]\n", verbose: false
        items = {}
        Dir[File.join(destination_root, 'changelog/unreleased/*.yml')].each do |file|
          yaml = YAML.load_file(file)
          items[yaml['type']] ||= []
          items[yaml['type']] << "#{yaml['title'].strip} (@#{yaml['author']})"
        end

        Changelog.natures.each.with_index do |nature, i|
          if changes = items[nature].presence
            append_to_file 'CHANGELOG.md', "### #{nature}\n", verbose: false
            changes.each do |change|
              append_to_file 'CHANGELOG.md', "- #{change}\n", verbose: false
            end
            append_to_file 'CHANGELOG.md', "\n", verbose: false, force: true unless i == Changelog.natures.size - 1
          end
        end
      end
    end
  end
end
