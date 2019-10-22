# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "validation"

class OCG
  def initialize(options)
    Validation.validate_options options

    @options = options
  end

  def and(object)
    @child_generator = get_generator object
  end

  def or(object)
    @child_generator = get_generator object
  end

  def mix(object)
    @child_generator = get_generator object
  end

  def next
  end

  def remaining_length
  end

  def length
  end

  private def get_generator(object)
    return object if object.is_a? OCG

    self.class.new object
  end
end
