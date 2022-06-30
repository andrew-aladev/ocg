# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "abstract"

class OCG
  module Operator
    # OCG::Operator::MIX class.
    class MIX < Abstract
      # Initializes current generators.
      def initialize(*args)
        super

        reset_main_generator
      end

      # Initializes copy of current generators.
      def initialize_copy(*args)
        super

        reset_main_generator
      end

      # Resets left or right generator based on internal state.
      def reset_main_generator
        @main_generator =
          if @right_generator.length > @left_generator.length
            @right_generator
          else
            @left_generator
          end
      end

      # Get next option combination result.
      def next
        return nil if finished?

        @left_generator.reset if @left_generator.finished?
        @right_generator.reset if @right_generator.finished?

        left  = @left_generator.next
        right = @right_generator.next

        merge_results left, right
      end

      # Get last option combination result.
      def last
        left  = @left_generator.last
        right = @right_generator.last

        merge_results left, right
      end

      # Is option combinations generation finished?
      def finished?
        @main_generator.finished?
      end

      # Is option combinations generation started?
      def started?
        @main_generator.started?
      end

      # Get options combination length.
      def length
        @main_generator.length
      end
    end
  end
end
