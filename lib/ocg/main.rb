# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "forwardable"

require_relative "error"
require_relative "options"

class OCG
  extend ::Forwardable

  DELEGATORS = %i[reset next last started? finished? length].freeze

  def initialize(generator_or_options)
    @generator = self.class.prepare_generator generator_or_options
  end

  def self.prepare_generator(generator_or_options)
    return generator_or_options if generator_or_options.is_a? OCG

    Options.new generator_or_options
  end

  def_delegators :@generator, *DELEGATORS

  def and(generator_or_options)
    Operator::AND.new self, generator_or_options
  end

  def mix(generator_or_options)
    Operator::MIX.new self, generator_or_options
  end

  def or(generator_or_options)
    Operator::OR.new self, generator_or_options
  end

  def to_a
    reset

    result = []
    result << send("next") until finished?

    reset

    result
  end
end

require_relative "operator/and"
require_relative "operator/mix"
require_relative "operator/or"
