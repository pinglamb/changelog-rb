require 'spec_helper'

RSpec.describe Changelog::Setup do
  let(:setup) {
    Changelog::Setup.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  }

  it 'creates directory ./changelog' do
    setup.go
    expect(File).to exist(changelog_root)
  end

  it 'creates directory ./changelog/unreleased' do
    setup.go
    expect(File).to exist("#{changelog_root}/unreleased")
  end

  it 'creates file ./changelog/unreleased/.gitkeep' do
    setup.go
    expect(File).to exist("#{changelog_root}/unreleased/.gitkeep")
  end

  it 'is invoked multiple times without unexpected side effects' do
    setup.go
    old_md5sum = check_md5sum_of(changelog_root)

    setup.go
    setup.go
    new_md5sum = check_md5sum_of(changelog_root)
    expect(new_md5sum).to eq(old_md5sum)

    expect(File).to exist(changelog_root)
    expect(File).to exist("#{changelog_root}/unreleased")
    expect(File).to exist("#{changelog_root}/unreleased/.gitkeep")
  end
end
