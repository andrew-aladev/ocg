# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "../error"

class OCG
  module Operator
    # OCG::Operator::Abstract class.
    class Abstract < OCG
      VARIABLES_TO_COPY = %i[left_generator right_generator].freeze

      # Initializes operator using +left_generator_or_options+ and +right_generator_or_options+.
      # Internaly object initializes left and right generators.
      def initialize(left_generator_or_options, right_generator_or_options) # rubocop:disable Lint/MissingSuper
        @left_generator  = OCG.prepare_generator left_generator_or_options
        @right_generator = OCG.prepare_generator right_generator_or_options

        reset
      end

      # Resets left and right generators specifically for options.
      def reset
        @left_generator.reset
        @right_generator.reset

        nil
      end

      # Merges results specifically for options.
      protected def merge_results(left, right)
        if left.nil?
          right
        elsif right.nil?
          left
        else
          left.merge right
        end
      end

      # :nocov:
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
      # :nocov:
    end
  end
end
