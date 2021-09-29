# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Reset < Minitest::Test
      def test_before_started
        Test.get_datas do |generator, combinations|
          assert_nil generator.last

          generator.reset
          assert_nil generator.last
          test_first_option generator, combinations
        end
      end

      def test_before_finished
        Test.get_datas do |generator, combinations|
          assert_nil generator.last

          test_first_option generator, combinations

          generator.reset
          assert_nil generator.last
          test_first_option generator, combinations
        end
      end

      def test_after_finished
        Test.get_datas do |generator, combinations|
          assert_nil generator.last

          combinations.each do |combination|
            assert_equal generator.next, combination
          end

          generator.reset
          assert_nil generator.last
          test_first_option generator, combinations
        end
      end

      protected def test_first_option(generator, combinations)
        if combinations.empty?
          assert_nil generator.next
        else
          assert_equal generator.next, combinations[0]
        end
      end
    end

    Minitest << Reset
  end
end
