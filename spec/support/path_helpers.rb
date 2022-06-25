module PathHelpers
  def gem_root_path
    File.expand_path('../../', File.dirname(__FILE__))
  end

  def fixture_path
    File.expand_path('spec/fixtures', gem_root_path)
  end

  def activesupport_gem_path
    Bundler.definition.specs.find {|s| s.name == 'activesupport'}.full_gem_path
  end

  def destination_root
    File.expand_path('spec/sandbox', gem_root_path)
  end

  def changelog_root
    Changelog.configuration.versions_path
  end

  def changelog_summary
    Changelog.configuration.summary_path
  end
end
