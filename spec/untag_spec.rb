# frozen_string_literal: true
require "spec_helper"

RSpec.describe Changelog::Untag do
  before do
    FileUtils.mkdir_p "#{changelog_root}/unreleased"
    FileUtils.cp_r "spec/fixtures/changelog-1/0.1.0", changelog_root
  end

  let(:shell) { subject.shell }

  it "removes the tag.yml in the version folder" do
    expect(File).to exist("#{changelog_root}/0.1.0/tag.yml")

    shell.mute { subject.go("0.1.0") }

    expect(File).not_to exist("#{changelog_root}/0.1.0/tag.yml")
  end

  it "moves the files in version folder to the unreleased folder" do
    shell.mute { subject.go("0.1.0") }

    expect(File).to exist("#{changelog_root}/unreleased/added_something.yml")
    expect(File).to exist("#{changelog_root}/unreleased/fixed_something.yml")
    expect(File).not_to exist("#{changelog_root}/unreleased/tag.yml")
  end

  it "removes the version folder" do
    shell.mute { subject.go("0.1.0") }

    expect(File).not_to exist("#{changelog_root}/0.1.0")
  end
end
