# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "date"

require_relative "lib/ocg/version"

GEMSPEC = Gem::Specification.new do |gem|
  gem.name     = "ocg"
  gem.summary  = "Option combination generator."
  gem.homepage = "https://github.com/andrew-aladev/ocg"
  gem.license  = "MIT"
  gem.authors  = File.read("AUTHORS").split("\n").reject(&:empty?)
  gem.email    = "aladjev.andrew@gmail.com"
  gem.version  = OCG::VERSION
  gem.date     = Date.today.to_s

  gem.add_development_dependency "minitest", "~> 5.12"
  gem.add_development_dependency "rubocop", "~> 0.75"
  gem.add_development_dependency "rubocop-performance", "~> 1.5"
  gem.add_development_dependency "rubocop-rails", "~> 2.3"

  gem.files = \
    `git ls-files -z --directory lib`.split("\x0") + \
    %w[AUTHORS LICENSE README.md]
  gem.require_paths = %w[lib]
end
