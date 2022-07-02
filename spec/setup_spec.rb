require 'spec_helper'

RSpec.describe Changelog::Setup do
  let(:shell) { subject.shell }

  it 'creates directory ./changelog' do
    shell.mute { subject.go }
    expect(File).to exist(changelog_root)
  end

  it 'creates directory ./changelog/unreleased' do
    shell.mute { subject.go }
    expect(File).to exist("#{changelog_root}/unreleased")
  end

  it 'creates file ./changelog/unreleased/.gitkeep' do
    shell.mute { subject.go }
    expect(File).to exist("#{changelog_root}/unreleased/.gitkeep")
  end

  it 'is invoked multiple times without unexpected side effects' do
    shell.mute { subject.go }
    old_md5sum = check_md5sum_of(changelog_root)

    shell.mute { subject.go }
    shell.mute { subject.go }
    new_md5sum = check_md5sum_of(changelog_root)
    expect(new_md5sum).to eq(old_md5sum)

    expect(File).to exist(changelog_root)
    expect(File).to exist("#{changelog_root}/unreleased")
    expect(File).to exist("#{changelog_root}/unreleased/.gitkeep")
  end
end
