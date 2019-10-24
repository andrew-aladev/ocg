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
          @left_generator.next.merge @right_generator.next
        else
          left_last = @left_generator.last
          left_last = @left_generator.next if left_last.nil?
          left_last.merge @right_generator.next
        end
      end

      def last
        left_last  = @left_generator.last
        right_last = @right_generator.last

        return nil if left_last.nil? || right_last.nil?

        left_last.merge right_last
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
