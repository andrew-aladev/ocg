# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "error"

class OCG
  OPERATORS = %i[add or mix].freeze

  module Validation
    def self.validate_generator(generator)
      return if generator.is_a? OCG

      raise ValidateError, "invalid hash" unless generator.is_a? ::Hash

      generator.each do |_key, value|
        raise ValidateError, "value has no length" unless value.respond_to? :length
        raise ValidateError, "value is not indexable" unless value.respond_to? :[]
      end
    end

    def self.validate_operator(operator)
      raise ValidateError, "invalid operator" unless OPERATORS.include? operator
    end
  end
end
