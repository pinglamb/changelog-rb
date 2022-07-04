# frozen_string_literal: true
require "spec_helper"

RSpec.describe Changelog::Show do
  before { FileUtils.cp_r("spec/fixtures/changelog-1", changelog_root) }

  context "when no version provided" do
    it "prints changes of unreleased and the lastest version" do
      content = "## [Unreleased]\n### Added\n- ✨ Added add script (@someone)\n- Added setup script (@someone)\n\n### Changed\n- ✨ Support getting title from git commit (@someone)\n\n### Deprecated\n- Deprecated something (@someone)\n\n### Removed\n- Removed something (@someone)\n\n### Fixed\n- Fixed something (@someone)\n\n### Security\n- Added Secure Stuff (@someone)\n## [0.3] - 2017-11-03\n### Added\n- Added something again (@someone)\n"
      expect { subject.go }.to output(content).to_stdout
    end
  end

  context "when valid version is provided" do
    it "prints changes of that version" do
      content = "## [0.2.1] - 2017-09-17\n### Fixed\n- Fixed something (@someone)\n"
      version = "0.2.1"
      expect { subject.go(version) }.to output(content).to_stdout
    end
  end

  context "when invalid version is provided" do
    it "prints error message" do
      content = "#{changelog_root}/0.2.2 not found\n"
      version = "0.2.2"
      expect { subject.go(version) }.to output(content).to_stdout
    end
  end
end
