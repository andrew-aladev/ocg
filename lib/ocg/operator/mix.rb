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
        @left_generator.next.merge @right_generator.next
      end

      def last
        left_last  = @left_generator.last
        right_last = @right_generator.last

        return nil if left_last.nil? || right_last.nil?

        left_last.merge right_last
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
