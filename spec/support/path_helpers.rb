# frozen_string_literal: true
module PathHelpers
  def gem_root
    File.expand_path("../../", File.dirname(__FILE__))
  end

  def destination_root
    File.expand_path("spec/sandbox", gem_root)
  end

  def changelog_root
    Changelog.configuration.versions_path
  end

  def changelog_summary
    Changelog.configuration.summary_path
  end
end
