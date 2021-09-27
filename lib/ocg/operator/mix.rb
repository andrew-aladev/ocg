# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "abstract"

class OCG
  module Operator
    class MIX < Abstract
      def initialize(*args)
        super

        reset_main_generator
      end

      def initialize_copy(*args)
        super

        reset_main_generator
      end

      def reset_main_generator
        @main_generator =
          if @right_generator.length > @left_generator.length
            @right_generator
          else
            @left_generator
          end
      end

      def next
        return nil if finished?

        @left_generator.reset if @left_generator.finished?
        @right_generator.reset if @right_generator.finished?

        left  = @left_generator.next
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
        @main_generator.started?
      end

      def finished?
        @main_generator.finished?
      end

      def length
        @main_generator.length
      end
    end
  end
end
