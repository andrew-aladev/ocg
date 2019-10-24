# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "options"
require_relative "validation"

class OCG
  OPERATORS = %i[add or mix].freeze

  def initialize(left_generator, operator = nil, right_generator = nil)
    @left_generator = self.class.initialize_generator left_generator

    raise ValidateError, "right generator is required for operator" if operator.nil? && !right_generator.nil?
    raise ValidateError, "operator is required for right generator" if !operator.nil? && right_generator.nil?

    return if operator.nil?

    Validation.validate_operator operator
    @operator = operator

    @right_generator = self.class.initialize_generator right_generator
  end

  private_class_method def self.initialize_generator(generator)
    return generator if generator.is_a? OCG

    Options.new generator
  end

  def and(generator)
    self.class.new self, :and, generator
  end

  def or(generator)
    self.class.new self, :or, generator
  end

  def mix(generator)
    self.class.new self, :mix, generator
  end

  def reset
    @left_generator.reset
    @right_generator.reset unless @operator.nil?

    nil
  end

  def next
    return nil if finished?

    case @operator
    when :and
      if @right_generator.finished?
        @right_generator.reset
        @left_generator.next.merge @right_generator.next
      else
        @left_generator.take.merge @right_generator.next
      end

    when :or
      if @left_generator.finished?
        @right_generator.next
      else
        @left_generator.next
      end

    else
      # :mix
      @right_generator.reset if @right_generator.finished?
      @left_generator.next.merge @right_generator.next
    end
  end

  def take
    case @operator
    when :and, :mix
      @left_generator.take.merge @right_generator.take
    else
      # :or
      if @left_generator.finished?
        @right_generator.take
      else
        @left_generator.take
      end
    end
  end

  def finished?
    case @operator
    when :and, :or
      @left_generator.finished? && @right_generator.finished?
    else
      # :mix
      @left_generator.finished?
    end
  end

  def length
    left_length = @left_generator.length
    return left_length if @operator.nil?

    right_length = @right_generator.length

    case @operator
    when :and
      left_length * right_length
    when :or
      left_length + right_length
    else
      # :mix
      left_length.length
    end
  end
end
