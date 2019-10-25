# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Last < Minitest::Unit::TestCase
      def test_basic
        generator, combinations = Test.get_data
        assert generator.last.nil?

        combinations.each do |combination|
          assert_equal generator.next, combination
          assert_equal generator.last, combination
        end

        assert_equal generator.last, combinations.last
      end

      def test_after_reset
        generator, combinations = Test.get_data
        assert generator.last.nil?

        assert_equal generator.next, combinations[0]
        assert_equal generator.last, combinations[0]

        generator.reset

        combinations.each do |combination|
          assert_equal generator.next, combination
          assert_equal generator.last, combination
        end

        assert_equal generator.last, combinations.last
      end
    end

    Minitest << Last
  end
end
