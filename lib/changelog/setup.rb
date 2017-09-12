require "thor"

module Changelog
  class Setup < Thor
    include Thor::Actions

    no_commands do
      def go
        empty_directory 'changelog'
        empty_directory 'changelog/unreleased'
        create_file 'changelog/unreleased/.gitkeep'

        true
      end
    end
  end
end
