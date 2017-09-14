require "bundler/setup"
require "fakefs/spec_helpers"
require "changelog-rb"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FakeFS::SpecHelpers

  config.before :all do
    @activesupport_gem_path = Bundler.definition.specs.find {|s| s.name == 'activesupport'}.full_gem_path
  end

  config.before :each do
    FakeFS::FileSystem.clone(File.expand_path('../../', __FILE__))
    FakeFS::FileSystem.clone(@activesupport_gem_path)
  end
end
