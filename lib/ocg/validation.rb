# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "error"

class OCG
  module Validation
    def self.validate_options(options)
      raise ValidateError, "invalid options hash" unless options.is_a? ::Hash
      raise ValidateError, "options should not be empty" if options.empty?

      options.each do |_name, values|
        raise ValidateError, "option values should provide length" unless values.respond_to? :length
        raise ValidateError, "option values are not indexable" unless values.respond_to? :[]
      end
    end

    def self.validate_operator(operator)
      raise ValidateError, "invalid operator" unless OCG::OPERATORS.include? operator
    end
  end
end
