# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "validation"

class OCG
  class Options
    def initialize(options)
      Validation.validate_options options
      @options = Hash[options.map { |name, values| [name, values.to_a] }]

      # End to start is more traditional way of making combinations.
      @keys = @options.keys.reverse

      reset_value_indexes

      @is_finished  = false
      @last_options = nil
    end

    protected def reset_value_indexes
      @value_indexes = Hash[@options.map { |name, _values| [name, 0] }]
    end

    def reset
      # If state is finished than all value indexes are already zero.
      reset_value_indexes unless @is_finished

      @is_finished  = false
      @last_options = nil

      nil
    end

    def next
      return nil if @is_finished

      @last_options = Hash[@value_indexes.map { |name, value_index| [name, @options[name][value_index]] }]

      @is_finished = @keys.all? do |name|
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

      @last_options
    end

    def last
      @last_options
    end

    def finished?
      @is_finished
    end

    def length
      @options.reduce(1) { |length, (_name, values)| length * values.length }
    end
  end
end
