# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "forwardable"

require_relative "copyable"
require_relative "error"
require_relative "options"

# OCG class.
class OCG
  include Copyable
  include ::Enumerable
  extend ::Forwardable

  # Current delegators.
  DELEGATORS = %i[reset next last started? finished? length].freeze

  # Current variables to copy.
  VARIABLES_TO_COPY = %i[generator].freeze

  # Define current delegators.
  def_delegators :@generator, *DELEGATORS

  # Initializes options generator using +generator_or_options+.
  # +generator_or_options+ may be +generator+ object or +options+.
  # +options+ is a hash with values convertable to array.
  def initialize(generator_or_options = {})
    @generator = self.class.prepare_generator generator_or_options
  end

  # Prepares options generator using +generator_or_options+.
  # +generator_or_options+ may be +generator+ object or +options+.
  # +options+ is a hash with values convertable to array.
  def self.prepare_generator(generator_or_options)
    return generator_or_options if generator_or_options.is_a? OCG

    Options.new generator_or_options
  end

  # Adds +generator_or_options+ to current option combinations generator.
  def and(generator_or_options = {})
    Operator::AND.new self, generator_or_options
  end

  # Mixes +generator_or_options+ with current option combinations generator.
  def mix(generator_or_options = {})
    Operator::MIX.new self, generator_or_options
  end

  # Mixes +generator_or_options+ with current option combinations generator.
  def or(generator_or_options = {})
    Operator::OR.new self, generator_or_options
  end

  # Processes each option combination.
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
