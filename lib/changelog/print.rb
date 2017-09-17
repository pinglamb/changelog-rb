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
        items = {
          'Added' => [],
          'Changed' => []
        }
        Dir[File.join(destination_root, 'changelog/unreleased/*.yml')].each do |file|
          yaml = YAML.load_file(file)
          items[yaml['type']] << "#{yaml['title'].strip} (@#{yaml['author']})"
        end
        items.each.with_index do |(k, v), i|
          unless v.empty?
            append_to_file 'CHANGELOG.md', "### #{k}\n", verbose: false
            v.each do |item|
              append_to_file 'CHANGELOG.md', "- #{item}\n", verbose: false
            end
            append_to_file 'CHANGELOG.md', "\n", verbose: false, force: true unless i == items.count - 1
          end
        end
      end
    end
  end
end
