require 'spec_helper'

RSpec.describe Changelog::Show do
  let(:show) do
    Changelog::Show.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  end

  it 'prints changes of unreleased and the lastest version ' do
    log = <<~EOS
      ## [Unreleased]
      ### Added
      - ✨ Added add script (@someone)
      - Added setup script (@someone)

      ### Changed
      - ✨ Support getting title from git commit (@someone)

      ### Deprecated
      - Deprecated something (@someone)

      ### Removed
      - Removed something (@someone)

      ### Fixed
      - Fixed something (@someone)

      ### Security
      - Added Secure Stuff (@someone)
      ## [0.3] - 2017-11-03
      ### Added
      - Added something again (@someone)
    EOS
    FileUtils.cp_r("#{fixture_path}/changelog-1", 'changelog')
    expect do
      show.go
    end.to output(log).to_stdout
  end

  it 'prints changes of the version' do
    FileUtils.cp_r("#{fixture_path}/changelog-1", 'changelog')
    expect do
      show.go('0.2.1')
    end.to output("## [0.2.1] - 2017-09-17\n### Fixed\n- Fixed something (@someone)\n").to_stdout
  end

  it 'reports error if version not found' do
    FileUtils.cp_r("#{fixture_path}/changelog-1", 'changelog')
    expect do
      show.go('0.2.2')
    end.to output("changelog/0.2.2 not found\n").to_stdout
  end
end
