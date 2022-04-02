# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "copyable"
require_relative "validation"

class OCG
  class Options
    include Copyable

    VARIABLES_TO_COPY = %i[options keys last_options value_indexes].freeze

    def initialize(options)
      Validation.validate_options options
      @options = options.transform_values(&:to_a)

      # End to start is more traditional way of making combinations.
      @keys = @options.keys.reverse

      @last_options = nil

      reset_value_indexes

      @is_finished = length.zero?
    end

    protected def reset_value_indexes
      @value_indexes = @options.transform_values { |_values| 0 }
    end

    def reset
      return nil unless started?

      @last_options = nil

      # If state is finished than all value indexes are already zero.
      reset_value_indexes unless @is_finished

      @is_finished = length.zero?

      nil
    end

    def next
      return nil if @is_finished

      @last_options = @value_indexes.to_h { |name, value_index| [name, @options[name][value_index]] }

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

    def started?
      !@last_options.nil?
    end

    def finished?
      @is_finished
    end

    def length
      @options.reduce(0) do |length, (_name, values)|
        if length.zero?
          values.length
        else
          length * values.length
        end
      end
    end
  end
end
