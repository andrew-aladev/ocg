# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "helper"
require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class ToArray < Minitest::Test
      def test_basic
        Test.get_datas do |generator, combinations|
          assert_equal generator.to_a, combinations
        end
      end

      def test_after_started
        Test.get_datas do |generator, combinations|
          assert_equal generator.next, combinations[0]

          assert_equal generator.to_a, combinations

          combinations.each do |combination|
            assert_equal generator.next, combination
          end
        end
      end

      def test_after_finished
        Test.get_datas do |generator, combinations|
          combinations.each do |combination|
            assert_equal generator.next, combination
          end

          assert_equal generator.to_a, combinations

          combinations.each do |combination|
            assert_equal generator.next, combination
          end
        end
      end
    end

    Minitest << ToArray
  end
end
