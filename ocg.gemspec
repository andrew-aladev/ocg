# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

lib_path = File.expand_path "lib", __dir__
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include? lib_path

require "ocg/version"

GEMSPEC = Gem::Specification.new do |gem|
  gem.name     = "ocg"
  gem.summary  = "Option combination generator."
  gem.homepage = "https://github.com/andrew-aladev/ocg"
  gem.license  = "MIT"
  gem.authors  = File.read("AUTHORS").split("\n").reject(&:empty?)
  gem.email    = "aladjev.andrew@gmail.com"
  gem.version  = OCG::VERSION

  gem.add_development_dependency "codecov"
  gem.add_development_dependency "json"
  gem.add_development_dependency "minitest", "~> 5.14"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rubocop", "~> 1.17"
  gem.add_development_dependency "rubocop-minitest", "~> 0.12"
  gem.add_development_dependency "rubocop-performance", "~> 1.11"
  gem.add_development_dependency "rubocop-rake", "~> 0.5"
  gem.add_development_dependency "simplecov"

  gem.files =
    `git ls-files -z --directory lib`.split("\x0") +
    %w[AUTHORS LICENSE README.md]
  gem.require_paths = %w[lib]

  gem.required_ruby_version = ">= 2.5"
end
