# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "error"

class OCG
  # OCG::Validation module.
  module Validation
    # Raises error when +options+ is not hash
    #   and option values are not convertable to array
    #   and option values are not empty.
    def self.validate_options(options)
      raise ValidateError, "invalid options hash" unless options.is_a? ::Hash

      options.each do |_name, values|
        raise ValidateError, "option values should respond to \"to_a\"" unless values.respond_to? :to_a
        raise ValidateError, "option values should not be empty" if values.to_a.empty?
      end
    end
  end
end
