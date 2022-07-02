require 'spec_helper'
require 'yaml'

# TODO
RSpec.describe Changelog::Add do
  let(:shell) { subject.shell }

  it 'creates directory ./changelog/unreleased if it does not exist' do
    expect(File).not_to exist("#{changelog_root}/unreleased")

    shell.mute { subject.go('Something', nature: 'Added', author: 'someone') }

    expect(File).to exist("#{changelog_root}/unreleased")
  end

  it 'generates the YAML file for the changelog item and add to ./changelog/unreleased' do
    shell.mute { subject.go('Added command for adding changelog item', nature: 'Added', author: 'someone') }

    expect(File).to exist("#{changelog_root}/unreleased/added_command_for_adding_changelog_item.yml")

    yaml = WorkaroundYAML.load_file("#{changelog_root}/unreleased/added_command_for_adding_changelog_item.yml")
    expect(yaml['type']).to eq('Added')
    expect(yaml['title']).to eq("Added command for adding changelog item\n")
    expect(yaml['author']).to eq('someone')
  end

  it 'guesses nature from title' do
    shell.mute { subject.go('Added command for adding changelog item') }

    yaml = WorkaroundYAML.load_file("#{changelog_root}/unreleased/added_command_for_adding_changelog_item.yml")
    expect(yaml['type']).to eq('Added')
  end

  it 'guesses nature from title in smart way' do
    {
      'add something' => 'Added',
      'new feature' => 'Added',
      'ADDED this' => 'Added',
      'update something' => 'Changed',
      'make this happen' => 'Changed',
      'fix something' => 'Fixed',
      'deprecate something' => 'Deprecated',
      'remove this and that' => 'Removed',
      'protect this' => 'Security'
    }.each do |title, nature|
      expect(subject.extract_nature_from_title(title)).to eq(nature)
    end
  end

  it 'guesses author from system' do
    allow(Changelog::Helpers::Shell).to receive(:system_user).and_return('someone')

    shell.mute { subject.go('Added command for adding changelog item') }

    yaml = WorkaroundYAML.load_file("#{changelog_root}/unreleased/added_command_for_adding_changelog_item.yml")
    expect(yaml['author']).to eq('someone')
  end

  it 'raises error if title is blank' do
    expect(subject).to receive(:say) {|message| message}
    expect(shell.mute { subject.go('') }).to eq("Error: title is blank\nchangelog add TITLE\nchangelog add -g")
  end

  it 'raises error if nature is not blank' do
    expect(subject).to receive(:say) {|message| message}
    expect(shell.mute { subject.go('I love changelog') }).to eq("Error: nature is blank\nchangelog add TITLE -t [#{Changelog.natures.join('|')}]")
  end

  it 'raises error if nature is not defined' do
    expect(subject).to receive(:say) {|message| message}
    expect(shell.mute { subject.go('I love changelog', nature: 'Modified') }).to eq("Error: nature is invalid\nchangelog add TITLE -t [#{Changelog.natures.join('|')}]")
  end

  it 'raises error if author is not blank' do
    expect(Changelog::Helpers::Shell).to receive(:system_user).and_return('')
    expect(subject).to receive(:say) {|message| message}
    expect(shell.mute { subject.go('Added command for adding changelog item') }).to eq("Error: author is blank\nchangelog add TITLE -u [author]")
  end

  it 'grabs git HEAD commit comment as title' do
    expect(Changelog::Helpers::Git).to receive(:comment).and_return('Added git support')
    shell.mute { subject.go('', git: 'HEAD') }
    expect(File).to exist("#{changelog_root}/unreleased/added_git_support.yml")

    yaml = WorkaroundYAML.load_file("#{changelog_root}/unreleased/added_git_support.yml")
    expect(yaml['title']).to eq("Added git support\n")
  end

  it 'handles emoji character in the title' do
    expect(Changelog::Helpers::Git).to receive(:comment).and_return('✨Added git support')
    shell.mute { subject.go('', git: 'HEAD') }
    expect(File).to exist("#{changelog_root}/unreleased/added_git_support.yml")

    yaml = WorkaroundYAML.load_file("#{changelog_root}/unreleased/added_git_support.yml")
    expect(yaml['title']).to eq("✨Added git support\n")
  end

  it 'handles emoji symbol in the title' do
    expect(Changelog::Helpers::Git).to receive(:comment).and_return(':sparkling: Added git support')
    shell.mute { subject.go('', git: 'HEAD') }
    expect(File).to exist("#{changelog_root}/unreleased/added_git_support.yml")

    yaml = WorkaroundYAML.load_file("#{changelog_root}/unreleased/added_git_support.yml")
    expect(yaml['title']).to eq("Added git support\n")
  end
end
