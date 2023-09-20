require 'bundler/setup'
require 'pp'
require 'active_support/testing/time_helpers'
require 'fakefs/spec_helpers'
require 'changelog-rb'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FakeFS::SpecHelpers
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Module.new {
                   def fixture_path
                     File.expand_path('../fixtures', __FILE__)
                   end
                 }

  config.before :all do
    @gem_root_path = File.expand_path('../../', __FILE__)
    @activesupport_gem_path =
      Bundler
        .definition
        .specs
        .find { |s| s.name == 'activesupport' }
        .full_gem_path
  end

  config.before :each do
    FakeFS::FileSystem.clone(File.join(@gem_root_path, 'lib/templates'))
    FakeFS::FileSystem.clone(File.join(@gem_root_path, 'spec/fixtures'))
    FakeFS::FileSystem.clone(
      File.join(@activesupport_gem_path, 'lib/active_support/values')
    )
    FakeFS::FileSystem.clone(
      File.join(@activesupport_gem_path, 'lib/active_support/locale')
    )
  end
end
