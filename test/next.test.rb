# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Next < Minitest::Unit::TestCase
      def test_basic
        Test.get_datas do |generator, combinations|
          combinations.each do |combination|
            assert_equal generator.next, combination
          end

          assert generator.next.nil?
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
          assert_equal generator.next, combinations[0]

          generator.reset

          combinations.each do |combination|
            assert_equal generator.next, combination
          end

          assert generator.next.nil?
        end
      end
    end

    Minitest << Next
  end
end
