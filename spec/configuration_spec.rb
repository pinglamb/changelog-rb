# frozen_string_literal: true
require "spec_helper"
require "fileutils"

RSpec.describe Changelog::Configuration do
  describe "default configuration" do
    it "has suggested versions_path and summary_path" do
      Changelog.configure do |config|
        config.versions_path = "changelog"
        config.summary_path = "CHANGELOG.md"
      end

      expect(changelog_summary).to eq("CHANGELOG.md")
      expect(changelog_root).to eq("changelog")
    end

    it "has configured versions_path and summary_path" do
      Changelog.configure do |config|
        config.versions_path = "tmp/changelog"
        config.summary_path = "tmp/CHANGELOG.md"
      end

      expect(changelog_root).to eq("tmp/changelog")
      expect(changelog_summary).to eq("tmp/CHANGELOG.md")
    end

    it "has configured versions_path" do
      Changelog.configure do |config|
        config.versions_path = "tmp/changelog"
        config.summary_path = "CHANGELOG.md"
      end

      expect(changelog_root).to eq("tmp/changelog")
      expect(changelog_summary).to eq("CHANGELOG.md")
    end

    it "has configured summary_path" do
      Changelog.configure do |config|
        config.versions_path = "changelog"
        config.summary_path = "tmp/CHANGELOG.md"
      end

      expect(changelog_root).to eq("changelog")
      expect(changelog_summary).to eq("tmp/CHANGELOG.md")
    end
  end
end

