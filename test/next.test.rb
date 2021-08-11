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
            assert_equal combination, generator.next
          end

          assert_nil generator.next
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
          assert_equal combinations[0], generator.next

          generator.reset

          combinations.each do |combination|
            assert_equal combination, generator.next
          end

          assert_nil generator.next
        end
      end
    end

    Minitest << Next
  end
end
