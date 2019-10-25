# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "ocg"

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Last < Minitest::Unit::TestCase
      def test_last
        generator, combinations = Test.get_data
        assert generator.last.nil?

        index = 0
        until generator.finished?
          assert_equal generator.next, combinations[index]
          assert_equal generator.last, combinations[index]
          index += 1
        end

        assert_equal generator.last, combinations.last
      end

      def test_last_after_reset
        generator, combinations = Test.get_data
        assert generator.last.nil?

        assert_equal generator.next, combinations[0]
        assert_equal generator.last, combinations[0]

        generator.reset

        index = 0
        until generator.finished?
          assert_equal generator.next, combinations[index]
          assert_equal generator.last, combinations[index]
          index += 1
        end

        assert_equal generator.last, combinations.last
      end
    end

    Minitest << Last
  end
end
