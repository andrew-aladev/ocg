# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

if ENV["CI"]
  pp ENV

  require "codecov"
  require "simplecov"

  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::Codecov
    ]
  )

  SimpleCov.start do
    add_filter %r{^/test/}
  end
end
