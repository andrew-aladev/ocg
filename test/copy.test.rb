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

            assert_nil generator.last
            refute generator.started?
            refute generator.finished?

            assert_nil generator_copy.last
            refute generator_copy.started?
            refute generator_copy.finished?

            first_combination  = combinations[0]
            other_combinations = combinations[1..-1]

            # Reading first combination from initial generator.

            assert_equal first_combination, generator.next
            assert_equal first_combination, generator.last
            assert generator.started?
            refute generator.finished?

            assert_nil generator_copy.last
            refute generator_copy.started?
            refute generator_copy.finished?

            # Reading first combination from generator copy.

            assert_equal first_combination, generator_copy.next
            assert_equal first_combination, generator_copy.last
            assert generator_copy.started?
            refute generator_copy.finished?

            assert_equal first_combination, generator.last
            assert generator.started?
            refute generator.finished?

            # Reading other combinations from initial generator.

            other_combinations.each do |combination|
              assert_equal combination, generator.next
              assert_equal combination, generator.last
            end

            assert_nil generator.next
            assert generator.started?
            assert generator.finished?

            assert_equal first_combination, generator_copy.last
            assert generator_copy.started?
            refute generator_copy.finished?

            # Reading other combinations from generator copy.

            other_combinations.each do |combination|
              assert_equal combination, generator_copy.next
              assert_equal combination, generator_copy.last
            end

            assert_nil generator_copy.next
            assert generator_copy.started?
            assert generator_copy.finished?

            assert_nil generator.next
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

            assert_equal first_combination, generator.next
            assert_equal first_combination, generator.last
            assert_nil generator_copy.last

            assert_equal first_combination, generator_copy.next
            assert_equal first_combination, generator_copy.last
            assert_equal first_combination, generator.last

            generator.reset
            assert_nil generator.last
            assert_equal first_combination, generator_copy.last

            generator_copy.reset
            assert_nil generator_copy.last
            assert_nil generator.last

            # Reading all combinations from generators.

            combinations.each do |combination|
              assert_equal combination, generator.next
              assert_equal combination, generator.last
            end

            assert_nil generator.next
            assert_nil generator_copy.last

            combinations.each do |combination|
              assert_equal combination, generator_copy.next
              assert_equal combination, generator_copy.last
            end

            assert_nil generator.next
            assert_nil generator_copy.next

            generator.reset
            assert_nil generator.last
            assert_nil generator_copy.next

            generator_copy.reset
            assert_nil generator.last
            assert_nil generator_copy.last
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

            assert_equal method == :clone, frozen_generator_copy.frozen?
          end
        end
      end
    end

    Minitest << Copy
  end
end
