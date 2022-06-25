require "thor"

module Changelog
  class Setup < Thor
    include Thor::Actions

    no_commands do
      def go
        empty_directory Changelog.configuration.versions_path
        empty_directory "#{Changelog.configuration.versions_path}/unreleased"
        create_file "#{Changelog.configuration.versions_path}/unreleased/.gitkeep"
      end
    end
  end
end
