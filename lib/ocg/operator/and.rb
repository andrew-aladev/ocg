# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "abstract"

class OCG
  module Operator
    # OCG::Operator::AND class.
    class AND < Abstract
      # Get next option combination result.
      def next
        return nil if finished?

        if @right_generator.finished?
          @right_generator.reset
          left = @left_generator.next
        else
          left = @left_generator.last
          left = @left_generator.next if left.nil?
        end

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
        @left_generator.finished? && @right_generator.finished?
      end

      # Is option combinations generation started?
      def started?
        @left_generator.started? || @right_generator.started?
      end

      # Get options combination length.
      def length
        left_length  = @left_generator.length
        right_length = @right_generator.length

        if left_length.zero?
          right_length
        elsif right_length.zero?
          left_length
        else
          left_length * right_length
        end
      end
    end
  end
end
