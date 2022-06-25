# frozen_string_literal: true

require "thor"

module Changelog
  class Untag < Thor
    include Thor::Actions

    no_commands do
      def go(version)
        @version = version

        remove_file "#{Changelog.configuration.versions_path}/#{@version}/tag.yml"

        empty_directory "#{Changelog.configuration.versions_path}/unreleased"
        shell.say_status :move, "#{Changelog.configuration.versions_path}/#{@version}/*.yml to #{Changelog.configuration.versions_path}/unreleased", :green unless shell.mute?
        FileUtils.mv(
          Dir[File.join(destination_root, "#{Changelog.configuration.versions_path}/#{@version}/*.yml")],
          File.join(destination_root, "#{Changelog.configuration.versions_path}/unreleased")
        )

        remove_file "#{Changelog.configuration.versions_path}/#{@version}"
      end
    end
  end
end
