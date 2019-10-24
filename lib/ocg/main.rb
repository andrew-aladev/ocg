# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "forwardable"

require_relative "error"
require_relative "options"

class OCG
  extend ::Forwardable

  DELEGATORS = %i[reset next last finished? length].freeze

  def initialize(generator)
    @generator = self.class.prepare_generator generator
  end

  def self.prepare_generator(generator)
    return generator if generator.is_a? OCG

    Options.new generator
  end

  def_delegators :@generator, *DELEGATORS

  def and(generator)
    Operator::AND.new self, generator
  end

  def or(generator)
    Operator::OR.new self, generator
  end

  def mix(generator)
    Operator::MIX.new self, generator
  end
end

require_relative "operator/and"
require_relative "operator/mix"
require_relative "operator/or"
