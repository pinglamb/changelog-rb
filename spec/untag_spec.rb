require 'spec_helper'

RSpec.describe Changelog::Untag do
  let(:untag) {
    Changelog::Untag.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  }

  it 'removes the tag.yml in the version folder' do
    expect(File).to exist("#{changelog_root}/0.1.0/tag.yml")
    untag.go('0.1.0')
    expect(File).not_to exist("#{changelog_root}/0.1.0/tag.yml")
  end

  it 'moves the files in version folder to the unreleased folder' do
    untag.go('0.1.0')
    expect(File).to exist("#{changelog_root}/unreleased/added_something.yml")
    expect(File).to exist("#{changelog_root}/unreleased/fixed_something.yml")
    expect(File).not_to exist("#{changelog_root}/unreleased/tag.yml")
  end

  it 'removes the version folder' do
    untag.go('0.1.0')
    expect(File).not_to exist("#{changelog_root}/0.1.0")
  end
end
