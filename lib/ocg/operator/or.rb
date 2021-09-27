# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "abstract"

class OCG
  module Operator
    class OR < Abstract
      def next
        return nil if finished?

        if @left_generator.finished?
          @right_generator.next
        else
          @left_generator.next
        end
      end

      def last
        left  = @left_generator.last
        right = @right_generator.last

        if right.nil?
          left
        else
          right
        end
      end

      def started?
        @left_generator.started? || @right_generator.started?
      end

      def finished?
        @left_generator.finished? && @right_generator.finished?
      end

      def length
        @left_generator.length + @right_generator.length
      end
    end
  end
end
