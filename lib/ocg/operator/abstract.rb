# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "../error"

class OCG
  module Operator
    class Abstract < OCG
      def initialize(left_generator, right_generator)
        @left_generator  = OCG.prepare_generator left_generator
        @right_generator = OCG.prepare_generator right_generator
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

      def finished?
        raise NotImplementedError, "\"finished?\" is not implemented"
      end

      def length
        raise NotImplementedError, "\"length\" is not implemented"
      end
    end
  end
end
