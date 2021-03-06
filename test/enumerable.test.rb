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
          assert_equal(combinations, generator.map { |combination| combination })
        when :to_a
          assert_equal combinations, generator.to_a
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
            assert_equal combinations[0], generator.next
            assert generator.started?

            process_method generator, combinations, method

            assert generator.started?
            assert_equal combinations[1], generator.next

            generator.reset
          end
        end
      end

      def test_after_finished
        Test.get_datas do |generator, combinations|
          METHODS.each do |method|
            combinations.each do |combination|
              assert_equal combination, generator.next
            end

            assert generator.finished?

            process_method generator, combinations, method

            assert generator.finished?
            assert generator.next.nil?

            generator.reset
          end
        end
      end
    end

    Minitest << Enumerable
  end
end
