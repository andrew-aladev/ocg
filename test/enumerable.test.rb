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
          assert_equal(generator.map { |combination| combination }, combinations)
        when :to_a
          assert_equal generator.to_a, combinations
        end
      end

      def test_basic
        Test.get_datas do |generator, combinations|
          METHODS.each do |method|
            process_method generator, combinations, method

            generator.reset
          end
        end
      end

      def test_after_started
        Test.get_datas do |generator, combinations|
          METHODS.each do |method|
            test_first_option generator, combinations

            process_method generator, combinations, method

            test_second_option generator, combinations

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

            assert generator.finished?

            process_method generator, combinations, method

            assert generator.finished?
            assert_nil generator.next

            generator.reset
          end
        end
      end

      protected def test_first_option(generator, combinations)
        if combinations.empty?
          assert_nil generator.next
          refute generator.started?
        else
          assert_equal generator.next, combinations[0]
          assert generator.started?
        end
      end

      protected def test_second_option(generator, combinations)
        if combinations.empty?
          refute generator.started?
          assert_nil generator.next
        else
          assert generator.started?
          assert_equal generator.next, combinations[1]
        end
      end
    end

    Minitest << Enumerable
  end
end
