require "thor"

module Changelog
  class Tag < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path('../../templates', __FILE__)
    end

    no_commands do
      def go(version, date: nil)
        @version = version
        @date = date || Date.today.to_s

        empty_directory "changelog/#{@version}"
        template 'tag.yml', "changelog/#{@version}/tag.yml"

        shell.say_status :move, "changelog/#{@version}/*.yml from changelog/unreleased", :green unless shell.mute?
        FileUtils.mv(
          Dir[File.join(destination_root, 'changelog/unreleased/*.yml')],
          File.join(destination_root, "changelog/#{@version}")
        )
      end
    end
  end
end
