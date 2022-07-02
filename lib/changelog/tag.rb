# frozen_string_literal: true

require "thor"

module Changelog
  class Tag < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path("../templates", __dir__)
    end

    no_commands do
      def go(version, date: nil)
        @version = version
        @date = date || Date.today.to_s

        empty_directory "#{Changelog.configuration.versions_path}/#{@version}"
        template "tag.yml", "#{Changelog.configuration.versions_path}/#{@version}/tag.yml"

        shell.say_status :move, "#{Changelog.configuration.versions_path}/unreleased/*.yml to #{Changelog.configuration.versions_path}/#{@version}/", :green unless shell.mute?
        FileUtils.mv(
          Dir[File.join(destination_root, "#{Changelog.configuration.versions_path}/unreleased/*.yml")],
          File.join(destination_root, "#{Changelog.configuration.versions_path}/#{@version}")
        )
      end
    end
  end
end
