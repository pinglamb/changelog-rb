require 'spec_helper'

RSpec.describe Changelog::Tag do
  let(:tag) {
    Changelog::Tag.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  }

  before do
    FileUtils.rm_rf "#{changelog_root}/0.1.0"
  end

  it 'creates the directory according to version provided' do
    tag.go('0.1.0')
    expect(File).to exist("#{changelog_root}/0.1.0")
  end

  it 'adds the tag.yml to the directory which stores the current date' do
    travel_to Date.today do
      tag.go('0.1.0')
      expect(File).to exist("#{changelog_root}/0.1.0/tag.yml")

      yaml = WorkaroundYAML.load_file("#{changelog_root}/0.1.0/tag.yml")
      expect(yaml['date']).to eq(Date.today)
    end
  end

  it 'supports customizing the date' do
    tag.go('0.1.0', date: '2016-07-01')
    yaml = WorkaroundYAML.load_file("#{changelog_root}/0.1.0/tag.yml")
    expect(yaml['date'].to_s).to eq('2016-07-01')
  end

  it 'moves the files in unreleased folder to the version folder' do
    tag.go('0.1.0')

    Dir["#{fixture_path}/changelog-1/unreleased/*.yml"].each do |path|
      filename = File.basename path
      expect(File).to exist("#{changelog_root}/0.1.0/#{filename}")
    end
  end
end
