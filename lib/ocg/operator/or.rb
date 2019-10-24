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
        left_last  = @left_generator.last
        right_last = @right_generator.last

        if @left_generator.finished? && !right_last.nil?
          right_last
        else
          left_last
        end
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
