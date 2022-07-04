# frozen_string_literal: true
module Changelog
  module Helpers
    class Git
      def self.comment(sha)
        `git show #{sha} -s --format=%B`.strip
      end

      def self.origin_url
        `git config --get remote.origin.url`.strip.presence
      end

      def self.tag(version)
        `git tag | grep "#{version}$"`.split("\n").first
      end

      def self.github_url
        if origin = origin_url
          if origin =~ /github\.com/
            if origin =~ /^https/
              origin
            else
              "https://github.com/#{origin.gsub(/git@.+:/, '').gsub(/\.git/, '')}"
            end
          end
        end
      end

      def self.compare_url(sha1, sha2)
        (base_url = github_url) && "#{base_url}/compare/#{sha1}...#{sha2}"
      end
    end
  end
end
