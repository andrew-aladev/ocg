# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "abstract"

class OCG
  module Operator
    class MIX < Abstract
      def next
        return nil if finished?

        @right_generator.reset if @right_generator.finished?
        @left_generator.next.merge @right_generator.next
      end

      def last
        left_last  = @left_generator.last
        right_last = @right_generator.last

        return nil if left_last.nil? || right_last.nil?

        left_last.merge right_last
      end

      def started?
        @left_generator.started?
      end

      def finished?
        @left_generator.finished?
      end

      def length
        @left_generator.length
      end
    end
  end
end
