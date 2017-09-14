require 'thor'
require 'changelog/helpers/shell'

module Changelog
  class Add < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path('../../templates', __FILE__)
    end


    no_commands do
      def go(title, nature = '', author = '')
        @title  = title
        @nature = nature.presence || extract_nature_from_title(@title)
        @author = author.presence || Changelog::Helpers::Shell.system_user

        raise 'title is blank' if @title.blank?
        raise 'nature is blank' if @nature.blank?
        raise 'nature is invalid' unless @nature.in?(Changelog.natures)
        raise 'author is blank' if @author.blank?

        filename = title.parameterize.underscore

        empty_directory 'changelog/unreleased' unless File.exists?('changelog/unreleased')
        template 'item.yml', "changelog/unreleased/#{filename}.yml"

        true
      end

      def extract_nature_from_title(title)
        first_word = title.split.first
        if Changelog.natures.include?(first_word)
          first_word
        else
          ''
        end
      end
    end
  end
end
