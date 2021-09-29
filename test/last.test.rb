# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Last < Minitest::Test
      def test_basic
        Test.get_datas do |generator, combinations|
          assert_nil generator.last

          combinations.each do |combination|
            assert_equal generator.next, combination
            assert_equal generator.last, combination
          end

          test_last_item generator, combinations
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
          assert_nil generator.last

          test_first_item generator, combinations

          generator.reset

          combinations.each do |combination|
            assert_equal generator.next, combination
            assert_equal generator.last, combination
          end

          test_last_item generator, combinations
        end
      end

      protected def test_first_item(generator, combinations)
        if combinations.empty?
          assert_nil generator.next
          assert_nil generator.last
        else
          assert_equal generator.next, combinations[0]
          assert_equal generator.last, combinations[0]
        end
      end

      protected def test_last_item(generator, combinations)
        if combinations.empty?
          assert_nil generator.last
        else
          assert_equal generator.last, combinations.last
        end
      end
    end

    Minitest << Last
  end
end
