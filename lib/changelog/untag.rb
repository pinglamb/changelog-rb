require "thor"

module Changelog
  class Untag < Thor
    include Thor::Actions

    no_commands do
      def go(version)
        @version = version

        remove_file "changelog/#{@version}/tag.yml"

        empty_directory 'changelog/unreleased'
        shell.say_status :move, "changelog/#{@version}/*.yml to changelog/unreleased", :green unless shell.mute?
        FileUtils.mv(
          Dir[File.join(destination_root, "changelog/#{@version}/*.yml")],
          File.join(destination_root, 'changelog/unreleased')
        )

        remove_file "changelog/#{@version}"
      end
    end
  end
end
