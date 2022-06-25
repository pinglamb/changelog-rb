require "bundler/setup"
require 'pp'
require 'pry'
require 'active_support/testing/time_helpers'
require "fakefs/spec_helpers"
require "changelog-rb"

require_relative 'support/md5sum_helpers'
require_relative 'support/path_helpers'

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FakeFS::SpecHelpers
  config.include ActiveSupport::Testing::TimeHelpers
  config.include PathHelpers
  config.include Md5sumHelpers

  config.before :each do
    FakeFS::FileSystem.clone(File.join(gem_root_path, 'lib/templates'))
    FakeFS::FileSystem.clone(File.join(gem_root_path, 'spec/fixtures'))
    FakeFS::FileSystem.clone(File.join(gem_root_path, 'spec/support'))
    FakeFS::FileSystem.clone(File.join(activesupport_gem_path, 'lib/active_support/values'))
    FakeFS::FileSystem.clone(File.join(activesupport_gem_path, 'lib/active_support/locale'))
  end
end

