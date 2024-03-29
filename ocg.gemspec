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
  gem.metadata = {
    "rubygems_mfa_required" => "true"
  }

  gem.files =
    `find lib -type f -name "*.rb" -print0`.split("\x0") +
    %w[AUTHORS LICENSE README.md]
  gem.require_paths = %w[lib]

  gem.required_ruby_version = ">= 2.6"
end
