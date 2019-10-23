# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "validation"

class OCG
  def initialize(left_generator, operator = nil, right_generator = nil)
    Validation.validate_generator left_generator
    @left_generator = left_generator

    Validation.validate_operator operator unless operator.nil?
    @operator = operator

    Validation.validate_generator right_generator unless right_generator.nil?
    @right_generator = right_generator
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

  def next
  end

  def remaining_length
  end

  def length
    if @left_generator
    end
  end
end
