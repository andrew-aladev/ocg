# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "error"

class OCG
  module Validation
    def self.validate_options(options)
      raise ValidateError, "invalid options hash" unless options.is_a? ::Hash
      raise ValidateError, "options should not be empty" if options.empty?

      options.each do |_name, values|
        raise ValidateError, "option values should respond to \"to_a\"" unless values.respond_to? :to_a
        raise ValidateError, "option values should not be empty" if values.to_a.empty?
      end
    end
  end
end
