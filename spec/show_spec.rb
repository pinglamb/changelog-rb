require 'spec_helper'

RSpec.describe Changelog::Show do
  let(:show) {
    Changelog::Show.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  }

  it 'prints changes of the version' do
    FileUtils.cp_r("#{fixture_path}/changelog-1", 'changelog')
    expect {
      show.go('0.2.1')
    }.to output("## [0.2.1] - 2017-09-17\n### Fixed\n- Fixed something (@someone)\n").to_stdout
  end

  it 'reports error if version not found' do
    FileUtils.cp_r("#{fixture_path}/changelog-1", 'changelog')
    expect {
      show.go('0.2.2')
    }.to output("changelog/0.2.2 not found\n").to_stdout
  end
end
