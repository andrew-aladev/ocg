# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "forwardable"

require_relative "copyable"
require_relative "error"
require_relative "options"

class OCG
  include Copyable
  include ::Enumerable
  extend ::Forwardable

  DELEGATORS        = %i[reset next last started? finished? length].freeze
  VARIABLES_TO_COPY = %i[generator].freeze

  def_delegators :@generator, *DELEGATORS

  def initialize(generator_or_options)
    @generator = self.class.prepare_generator generator_or_options
  end

  def self.prepare_generator(generator_or_options)
    return generator_or_options if generator_or_options.is_a? OCG

    Options.new generator_or_options
  end

  def and(generator_or_options)
    Operator::AND.new self, generator_or_options
  end

  def mix(generator_or_options)
    Operator::MIX.new self, generator_or_options
  end

  def or(generator_or_options)
    Operator::OR.new self, generator_or_options
  end

  def each(&_block)
    instance = dup
    instance.reset

    yield instance.next until instance.finished?

    nil
  end
end

require_relative "operator/and"
require_relative "operator/mix"
require_relative "operator/or"
