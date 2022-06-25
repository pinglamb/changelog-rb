require "bundler/setup"
require 'pp'
require 'pry'
require 'active_support/testing/time_helpers'
require "changelog-rb"

require_relative 'support/md5sum_helpers'
require_relative 'support/path_helpers'

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include ActiveSupport::Testing::TimeHelpers
  config.include PathHelpers
  config.include Md5sumHelpers

  config.around :each do |example|
    Changelog.configure do |config|
      config.versions_path = "spec/sandbox/changelog"
      config.summary_path = "spec/sandbox/CHANGELOG.md"
    end

    FileUtils.mkdir_p File.expand_path('spec/sandbox', gem_root_path)

    FileUtils.cp_r("#{fixture_path}/changelog-1", File.expand_path('spec/sandbox/changelog', gem_root_path))

    example.run

    FileUtils.rm_rf File.expand_path('spec/sandbox', gem_root_path)
  end
end

