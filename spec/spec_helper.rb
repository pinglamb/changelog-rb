# frozen_string_literal: true
require "bundler/setup"
require "pry"
require "changelog-rb"

require_relative "support/md5sum_helpers"
require_relative "support/path_helpers"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include PathHelpers
  config.include Md5sumHelpers

  sandbox_root = "spec/sandbox"

  config.around :each do |example|
    Changelog.configure do |config|
      config.versions_path = "#{sandbox_root}/changelog"
      config.summary_path  = "#{sandbox_root}/CHANGELOG.md"
    end

    FileUtils.mkdir_p sandbox_root

    example.run

    FileUtils.rm_rf sandbox_root
  end
end

