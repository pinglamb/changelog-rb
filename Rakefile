require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :flog do
  system "find lib -name \*.rb | xargs flog"
end

task :flay do
  system "flay lib/*.rb"
end

task :default => [:flog, :flay, :spec]
