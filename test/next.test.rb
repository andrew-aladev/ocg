# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Next < Minitest::Unit::TestCase
      def test_basic
        generator, combinations = Test.get_data

        combinations.each do |combination|
          assert_equal generator.next, combination
        end

        assert generator.next.nil?
      end

      def test_after_reset
        generator, combinations = Test.get_data
        assert_equal generator.next, combinations[0]

        generator.reset

        combinations.each do |combination|
          assert_equal generator.next, combination
        end

        assert generator.next.nil?
      end
    end

    Minitest << Next
  end
end
