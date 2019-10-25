# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "ocg"

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Reset < Minitest::Unit::TestCase
      def test_reset_before_started
        generator, combinations = Test.get_data
        assert generator.last.nil?

        generator.reset
        assert generator.last.nil?
        assert_equal generator.next, combinations[0]
      end

      def test_reset_before_finished
        generator, combinations = Test.get_data
        assert generator.last.nil?
        assert_equal generator.next, combinations[0]

        generator.reset
        assert generator.last.nil?
        assert_equal generator.next, combinations[0]
      end

      def test_reset_after_finished
        generator, combinations = Test.get_data
        assert generator.last.nil?

        index = 0
        until generator.finished?
          assert_equal generator.next, combinations[index]
          index += 1
        end

        generator.reset
        assert generator.last.nil?
        assert_equal generator.next, combinations[0]
      end
    end

    Minitest << Reset
  end
end
