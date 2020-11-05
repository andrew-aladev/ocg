# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Copy < Minitest::Test
      METHODS = %i[clone dup].freeze

      def test_basic
        METHODS.each do |method|
          Test.get_datas do |generator, combinations|
            generator_copy = generator.send method

            assert generator.last.nil?
            refute generator.started?
            refute generator.finished?

            assert generator_copy.last.nil?
            refute generator_copy.started?
            refute generator_copy.finished?

            first_combination  = combinations[0]
            other_combinations = combinations[1..-1]

            # Reading first combination from initial generator.

            assert_equal generator.next, first_combination
            assert_equal generator.last, first_combination
            assert generator.started?
            refute generator.finished?

            assert generator_copy.last.nil?
            refute generator_copy.started?
            refute generator_copy.finished?

            # Reading first combination from generator copy.

            assert_equal generator_copy.next, first_combination
            assert_equal generator_copy.last, first_combination
            assert generator_copy.started?
            refute generator_copy.finished?

            assert_equal generator.last, first_combination
            assert generator.started?
            refute generator.finished?

            # Reading other combinations from initial generator.

            other_combinations.each do |combination|
              assert_equal generator.next, combination
              assert_equal generator.last, combination
            end

            assert generator.next.nil?
            assert generator.started?
            assert generator.finished?

            assert_equal generator_copy.last, first_combination
            assert generator_copy.started?
            refute generator_copy.finished?

            # Reading other combinations from generator copy.

            other_combinations.each do |combination|
              assert_equal generator_copy.next, combination
              assert_equal generator_copy.last, combination
            end

            assert generator_copy.next.nil?
            assert generator_copy.started?
            assert generator_copy.finished?

            assert generator.next.nil?
            assert generator.started?
            assert generator.finished?
          end
        end
      end

      def test_reset
        METHODS.each do |method|
          Test.get_datas do |generator, combinations|
            generator_copy    = generator.send method
            first_combination = combinations[0]

            # Reading first combination from generators.

            assert_equal generator.next, first_combination
            assert_equal generator.last, first_combination
            assert generator_copy.last.nil?

            assert_equal generator_copy.next, first_combination
            assert_equal generator_copy.last, first_combination
            assert_equal generator.last, first_combination

            generator.reset
            assert generator.last.nil?
            assert_equal generator_copy.last, first_combination

            generator_copy.reset
            assert generator_copy.last.nil?
            assert generator.last.nil?

            # Reading all combinations from generators.

            combinations.each do |combination|
              assert_equal generator.next, combination
              assert_equal generator.last, combination
            end

            assert generator.next.nil?
            assert generator_copy.last.nil?

            combinations.each do |combination|
              assert_equal generator_copy.next, combination
              assert_equal generator_copy.last, combination
            end

            assert generator.next.nil?
            assert generator_copy.next.nil?

            generator.reset
            assert generator.last.nil?
            assert generator_copy.next.nil?

            generator_copy.reset
            assert generator.last.nil?
            assert generator_copy.last.nil?
          end
        end
      end

      def test_others
        METHODS.each do |method|
          Test.get_datas do |generator|
            generator_copy = generator.send method

            assert_equal generator.length, generator_copy.length

            # Clone should keep frozen state.

            frozen_generator      = generator.freeze
            frozen_generator_copy = frozen_generator.send method

            assert_equal frozen_generator_copy.frozen?, method == :clone
          end
        end
      end
    end

    Minitest << Copy
  end
end
