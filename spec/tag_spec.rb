require 'spec_helper'

RSpec.describe Changelog::Tag do
  let(:tag) {
    Changelog::Tag.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  }

  it 'creates the directory according to version provided' do
    tag.go('0.1.0')
    expect(File).to exist('changelog/0.1.0')
  end

  it 'adds the tag.yml to the directory which stores the current date' do
    travel_to Date.today do
      tag.go('0.1.0')
      expect(File).to exist('changelog/0.1.0/tag.yml')

      yaml = YAML.load_file('changelog/0.1.0/tag.yml')
      expect(yaml['date']).to eq(Date.today)
    end
  end

  it 'moves the files in unreleased folder to the version folder' do
    FileUtils.mkdir('changelog')
    FileUtils.cp_r("#{fixture_path}/changelog-1/unreleased", 'changelog/unreleased')
    tag.go('0.1.0')

    Dir["#{fixture_path}/changelog-1/unreleased/*.yml"].each do |path|
      filename = File.basename path
      expect(File).to exist("changelog/0.1.0/#{filename}")
    end
  end
end
