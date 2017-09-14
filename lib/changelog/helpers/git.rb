module Changelog
  module Helpers
    class Git
      def self.comment(sha)
        `git show #{sha} -s --format=%B`.strip
      end
    end
  end
end
