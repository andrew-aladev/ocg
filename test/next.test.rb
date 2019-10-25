# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "ocg"

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Next < Minitest::Unit::TestCase
      def test_next
        generator, combinations = Test.get_data

        index = 0
        until generator.finished?
          assert_equal generator.next, combinations[index]
          index += 1
        end

        assert generator.next.nil?
      end

      def test_next_after_reset
        generator, combinations = Test.get_data
        assert_equal generator.next, combinations[0]

        generator.reset

        index = 0
        until generator.finished?
          assert_equal generator.next, combinations[index]
          index += 1
        end

        assert generator.next.nil?
      end
    end

    Minitest << Next
  end
end
