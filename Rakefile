require "rake/testtask"
require "rdoc/task"
require "rubygems/package_task"

load "ocg.gemspec"

Rake::TestTask.new do |task|
  task.libs << %w[lib]

  pathes          = `find test | grep "\.test\.rb$"`
  task.test_files = pathes.split("\n")
end

RDoc::Task.new do |rdoc|
  rdoc.title    = "OCG rdoc"
  rdoc.main     = "README.md"
  rdoc.rdoc_dir = "docs"
  rdoc.rdoc_files.include "lib/**/*.rb", "AUTHORS", "LICENSE", "README.md"
end

task :default => %i[test]

Gem::PackageTask.new(GEMSPEC).define
