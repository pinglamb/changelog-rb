require 'spec_helper'

RSpec.describe Changelog::Print do
  before { FileUtils.cp_r("spec/fixtures/changelog-1", changelog_root) }

  let(:shell) { subject.shell }

  it 'prints to CHANGELOG.md according to changelog folder' do
    allow(Changelog::Helpers::Git).to receive(:origin_url).and_return('git@github.com:username/repo.git')
    allow(Changelog::Helpers::Git).to receive(:tag) { |version| "v#{version}" }

    shell.mute { subject.go }

    expect(File).to exist(changelog_summary)
    expect(File.read(changelog_summary)).to eq(File.read("spec/fixtures/CHANGELOG-1.md"))
    expect(check_md5sum_of(changelog_summary)).to eq(check_md5sum_of("spec/fixtures/CHANGELOG-1.md"))
  end
end
