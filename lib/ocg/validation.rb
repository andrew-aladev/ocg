# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "error"

class OCG
  module Validation
    def self.validate_options(options)
      raise ValidateError, "invalid hash" unless options.is_a? ::Hash

      options.each do |key, value|
        raise ValidateError, "invalid symbol" unless key.is_a? ::Symbol
        raise ValidateError, "not convertable to array" unless value.respond_to? :to_a
      end
    end
  end
end
