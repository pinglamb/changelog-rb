require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :flog do
  system "find lib -name \*.rb | xargs flog"
end

task :flay do
  system "flay lib/*.rb"
end

namespace :lint do
  task :magic_comment do
    system "rubocop -A --only Style/FrozenStringLiteralComment"
  end

  task :double_quotes do
    system "rubocop -A --only Style/StringLiterals"
  end
end

task :default => [:flog, :flay, :spec]
