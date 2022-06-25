require 'thor'
require 'changelog/helpers/shell'
require 'changelog/helpers/git'

module Changelog
  class Add < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path('../templates', __dir__)
    end

    no_commands do
      def go(title, nature: '', author: '', git: nil)
        @title = if git.nil?
          title
        else
          git = git.presence || 'HEAD'
          Changelog::Helpers::Git.comment(git)
        end
        @title = @title.gsub(/:\w+:/, '')
        @nature = nature.presence || extract_nature_from_title(@title)
        @author = author.presence || Changelog::Helpers::Shell.system_user

        if @title.blank?
          return say("Error: title is blank\nchangelog add TITLE\nchangelog add -g")
        end
        if @nature.blank?
          return say("Error: nature is blank\nchangelog add TITLE -t [#{Changelog.natures.join('|')}]")
        end
        unless @nature.in?(Changelog.natures)
          return say("Error: nature is invalid\nchangelog add TITLE -t [#{Changelog.natures.join('|')}]")
        end
        if @author.blank?
          return say("Error: author is blank\nchangelog add TITLE -u [author]")
        end

        filename = @title.parameterize.underscore

        empty_directory "#{Changelog.configuration.versions_path}/unreleased" unless File.exists?("#{Changelog.configuration.versions_path}/unreleased")
        template 'item.yml', "#{Changelog.configuration.versions_path}/unreleased/#{filename}.yml"

        true
      end

      def extract_nature_from_title(title)
        first_word = title.parameterize.split('-').first.try(:capitalize)
        guess_nature_from_word(first_word) || ''
      end

      def guess_nature_from_word(word)
        return word if word.blank?

        Changelog.dictionary.each do |nature, words|
          if words.include?(word.downcase)
            return nature
          end
        end

        nil
      end
    end
  end
end
