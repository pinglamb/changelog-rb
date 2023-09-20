require 'spec_helper'

RSpec.describe Changelog::Untag do
  let(:untag) do
    Changelog::Untag.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  end

  it 'removes the tag.yml in the version folder' do
    FileUtils.mkdir('changelog')
    FileUtils.cp_r("#{fixture_path}/changelog-1/0.1.0", 'changelog/0.1.0')
    expect(File).to exist('changelog/0.1.0/tag.yml')
    untag.go('0.1.0')
    expect(File).not_to exist('changelog/0.1.0/tag.yml')
  end

  it 'moves the files in version folder to the unreleased folder' do
    FileUtils.mkdir('changelog')
    FileUtils.cp_r("#{fixture_path}/changelog-1/0.1.0", 'changelog/0.1.0')
    untag.go('0.1.0')
    expect(File).to exist('changelog/unreleased/added_something.yml')
    expect(File).to exist('changelog/unreleased/fixed_something.yml')
    expect(File).not_to exist('changelog/unreleased/tag.yml')
  end

  it 'removes the version folder' do
    FileUtils.mkdir('changelog')
    FileUtils.cp_r("#{fixture_path}/changelog-1/0.1.0", 'changelog/0.1.0')
    untag.go('0.1.0')
    expect(File).not_to exist('changelog/0.1.0')
  end
end
