# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Next < Minitest::Test
      def test_basic
        Test.get_datas do |generator, combinations|
          combinations.each do |combination|
            assert_equal generator.next, combination
          end

          assert_nil generator.next
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
          test_first_item generator, combinations

          generator.reset

          combinations.each do |combination|
            assert_equal generator.next, combination
          end

          assert_nil generator.next
        end
      end

      protected def test_first_item(generator, combinations)
        if combinations.empty?
          assert_nil generator.next
        else
          assert_equal generator.next, combinations[0]
        end
      end
    end

    Minitest << Next
  end
end
