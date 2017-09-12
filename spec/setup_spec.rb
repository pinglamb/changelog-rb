require 'spec_helper'

RSpec.describe Changelog::Setup do
  let(:setup) {
    Changelog::Setup.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  }

  it 'creates directory ./changelog' do
    setup.go
    expect(File).to exist('changelog')
  end

  it 'creates directory ./changelog/unreleased' do
    setup.go
    expect(File).to exist('changelog/unreleased')
  end

  it 'creates file ./changelog/unreleased/.gitkeep' do
    setup.go
    expect(File).to exist('changelog/unreleased/.gitkeep')
  end
end
