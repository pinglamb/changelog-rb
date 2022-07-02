require 'spec_helper'

RSpec.describe Changelog::Tag do
  before do
    FileUtils.mkdir_p "#{changelog_root}/unreleased"
    FileUtils.cp_r "spec/fixtures/changelog-1/unreleased", changelog_root
  end

  let(:shell) { subject.shell }

  it 'creates version folder' do
    shell.mute { subject.go('0.1.0') }
    expect(File).to exist("#{changelog_root}/0.1.0")
  end

  it 'creates tag.yml in version folder' do
    shell.mute { subject.go('0.1.0') }
    expect(File).to exist("#{changelog_root}/0.1.0/tag.yml")
  end

  it 'moves files from unreleased folder to version folder' do
    shell.mute { subject.go('0.1.0') }

    Dir["spec/fixtures/changelog-1/unreleased/*.yml"].each do |path|
      filename = File.basename path
      expect(File).to exist("#{changelog_root}/0.1.0/#{filename}")
    end
  end

  context 'when date provided' do
    it 'stores provided date in tag.yml' do
      shell.mute { subject.go('0.1.0', date: '2016-07-01') }

      yaml = WorkaroundYAML.load_file("#{changelog_root}/0.1.0/tag.yml")
      expect(yaml['date'].to_s).to eq('2016-07-01')
    end
  end

  context 'when date not provided' do
    it 'stores current date in tag.yml' do
      shell.mute { subject.go('0.1.0') }

      yaml = WorkaroundYAML.load_file("#{changelog_root}/0.1.0/tag.yml")
      expect(yaml['date'].to_s).to eq(Date.today.to_s)
    end
  end
end
