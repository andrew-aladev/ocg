# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "../error"

class OCG
  module Operator
    class Abstract < OCG
      def initialize(left_generator_or_options, right_generator_or_options)
        @left_generator  = OCG.prepare_generator left_generator_or_options
        @right_generator = OCG.prepare_generator right_generator_or_options

        reset
      end

      def reset
        @left_generator.reset
        @right_generator.reset

        nil
      end

      def next
        raise NotImplementedError, "\"next\" is not implemented"
      end

      def last
        raise NotImplementedError, "\"last\" is not implemented"
      end

      def started?
        raise NotImplementedError, "\"started?\" is not implemented"
      end

      def finished?
        raise NotImplementedError, "\"finished?\" is not implemented"
      end

      def length
        raise NotImplementedError, "\"length\" is not implemented"
      end
    end
  end
end
