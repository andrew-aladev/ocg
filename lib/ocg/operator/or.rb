# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "abstract"

class OCG
  module Operator
    # OCG::Operator::OR class.
    class OR < Abstract
      # Get next option combination result.
      def next
        return nil if finished?

        if @left_generator.finished?
          @right_generator.next
        else
          @left_generator.next
        end
      end

      # Get last option combination result.
      def last
        left  = @left_generator.last
        right = @right_generator.last

        if right.nil?
          left
        else
          right
        end
      end

      # Is option combinations generation started?
      def started?
        @left_generator.started? || @right_generator.started?
      end

      # Is option combinations generation finished?
      def finished?
        @left_generator.finished? && @right_generator.finished?
      end

      # Get option combinations length.
      def length
        @left_generator.length + @right_generator.length
      end
    end
  end
end
