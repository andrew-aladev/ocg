# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Enumerable < Minitest::Test
      METHODS = %i[each map to_a].freeze

      def process_method(generator, combinations, method)
        case method
        when :each
          generator.each_with_index do |combination, index|
            assert_equal combination, combinations[index]
          end
        when :map
          target_combinations = generator.map { |combination| combination }
          assert_equal target_combinations, combinations
        when :to_a
          assert_equal generator.to_a, combinations
        end
      end

      def test_basic
        Test.get_datas do |generator, combinations|
          METHODS.each do |method|
            process_method generator, combinations, method
          end
        end
      end

      def test_after_started
        Test.get_datas do |generator, combinations|
          METHODS.each do |method|
            assert_equal generator.next, combinations[0]

            process_method generator, combinations, method

            combinations.each do |combination|
              assert_equal generator.next, combination
            end

            generator.reset
          end
        end
      end

      def test_after_finished
        Test.get_datas do |generator, combinations|
          METHODS.each do |method|
            combinations.each do |combination|
              assert_equal generator.next, combination
            end

            process_method generator, combinations, method

            combinations.each do |combination|
              assert_equal generator.next, combination
            end

            generator.reset
          end
        end
      end
    end

    Minitest << Enumerable
  end
end
