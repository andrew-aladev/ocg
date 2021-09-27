# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "abstract"

class OCG
  module Operator
    class AND < Abstract
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

        return nil if left.nil? || right.nil?

        left.merge right
      end

      def last
        left  = @left_generator.last
        right = @right_generator.last

        return nil if left.nil? || right.nil?

        left.merge right
      end

      def started?
        @left_generator.started? || @right_generator.started?
      end

      def finished?
        @left_generator.finished? && @right_generator.finished?
      end

      def length
        @left_generator.length * @right_generator.length
      end
    end
  end
end
