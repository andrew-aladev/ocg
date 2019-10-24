# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "validation"

class OCG
  class Options
    def initialize(options)
      Validation.validate_options options
      @options = options

      reset_value_indexes

      @is_finished = false
    end

    protected def reset_value_indexes
      @value_indexes = Hash[@options.map { |name, _values| [name, 0] }]
    end

    def reset
      # If state is finished than all value indexes are already zero.
      reset_value_indexes unless @is_finished

      @is_finished = false
    end

    def next
      return nil if @is_finished

      options = take

      @is_finished = @options.keys.all? do |name|
        values          = @options[name]
        new_value_index = @value_indexes[name] + 1

        if new_value_index < values.length
          @value_indexes[name] = new_value_index
          next false
        end

        # Reset value index to zero.
        @value_indexes[name] = 0
        true
      end

      options
    end

    def take
      Hash[@value_indexes.map { |name, value_index| [name, @options[name][value_index]] }]
    end

    def finished?
      @is_finished
    end

    def length
      @options.reduce(1) { |length, (_name, values)| length * values.length }
    end
  end
end
