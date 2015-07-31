require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require 'wwtd/tasks'
task :local => "wwtd:local"

if ENV["TRAVIS"] || ENV["INSIDE_WWTD"]
  task :default => :spec
else
  task :default => :wwtd
end
