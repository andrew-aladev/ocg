# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Last < Minitest::Test
      def test_basic
        Test.get_datas do |generator, combinations|
          assert generator.last.nil?

          combinations.each do |combination|
            assert_equal generator.next, combination
            assert_equal generator.last, combination
          end

          assert_equal generator.last, combinations.last
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
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
    end

    Minitest << Last
  end
end
