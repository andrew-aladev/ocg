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

            test_option generator, combinations, nil
            test_option generator_copy, combinations, nil

            first_combination  = combinations[0]
            other_combinations = combinations[1..] || []

            # Reading first combination from initial generator.

            if first_combination.nil?
              assert_nil generator.next
            else
              assert_equal generator.next, first_combination
            end

            test_option generator, combinations, 0
            test_option generator_copy, combinations, nil

            # Reading first combination from generator copy.

            if first_combination.nil?
              assert_nil generator_copy.next
            else
              assert_equal generator_copy.next, first_combination
            end

            test_option generator, combinations, 0
            test_option generator_copy, combinations, 0

            # Reading other combinations from initial generator.

            other_combinations.each do |combination|
              assert_equal generator.next, combination
              assert_equal generator.last, combination
            end

            test_option generator, combinations, combinations.length
            test_option generator_copy, combinations, 0

            # Reading other combinations from generator copy.

            other_combinations.each do |combination|
              assert_equal combination, generator_copy.next
              assert_equal combination, generator_copy.last
            end

            test_option generator, combinations, combinations.length
            test_option generator_copy, combinations, combinations.length
          end
        end
      end

      def test_reset
        METHODS.each do |method|
          Test.get_datas do |generator, combinations|
            generator_copy = generator.send method

            test_option generator, combinations, nil
            test_option generator_copy, combinations, nil

            first_combination = combinations[0]

            # Reading first combination from generators.

            if first_combination.nil?
              assert_nil generator.next
              assert_nil generator_copy.next
            else
              assert_equal generator.next, first_combination
              assert_equal generator_copy.next, first_combination
            end

            test_option generator, combinations, 0
            test_option generator_copy, combinations, 0

            generator.reset

            test_option generator, combinations, nil
            test_option generator_copy, combinations, 0

            generator_copy.reset

            test_option generator, combinations, nil
            test_option generator_copy, combinations, nil

            # Reading all combinations from generators.

            combinations.each do |combination|
              assert_equal generator.next, combination
              assert_equal generator.last, combination
              assert_equal generator_copy.next, combination
              assert_equal generator_copy.last, combination
            end

            test_option generator, combinations, combinations.length
            test_option generator_copy, combinations, combinations.length

            generator.reset

            test_option generator, combinations, nil
            test_option generator_copy, combinations, combinations.length

            generator_copy.reset

            test_option generator, combinations, nil
            test_option generator_copy, combinations, nil
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

      protected def test_option(generator, combinations, index)
        if index.nil?
          assert_nil generator.last
          refute_predicate generator, :started?

          if combinations.empty?
            assert_predicate generator, :finished?
          else
            refute_predicate generator, :finished?
          end
        elsif index >= combinations.length
          last_combination = combinations.last
          if last_combination.nil?
            assert_nil generator.last
          else
            assert_equal generator.last, last_combination
          end

          if combinations.empty?
            refute_predicate generator, :started?
          else
            assert_predicate generator, :started?
          end

          assert_predicate generator, :finished?
        else
          combination = combinations[index]
          if combination.nil?
            assert_nil generator.last
          else
            assert_equal generator.last, combination
          end

          assert_predicate generator, :started?

          if index + 1 < combinations.length
            refute_predicate generator, :finished?
          else
            assert_predicate generator, :finished?
          end
        end
      end
    end

    Minitest << Copy
  end
end
