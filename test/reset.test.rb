# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Reset < Minitest::Test
      def test_before_started
        Test.get_datas do |generator, combinations|
          assert generator.last.nil?

          generator.reset
          assert generator.last.nil?
          assert_equal combinations[0], generator.next
        end
      end

      def test_before_finished
        Test.get_datas do |generator, combinations|
          assert generator.last.nil?
          assert_equal combinations[0], generator.next

          generator.reset
          assert generator.last.nil?
          assert_equal combinations[0], generator.next
        end
      end

      def test_after_finished
        Test.get_datas do |generator, combinations|
          assert generator.last.nil?

          combinations.each do |combination|
            assert_equal combination, generator.next
          end

          generator.reset
          assert generator.last.nil?
          assert_equal combinations[0], generator.next
        end
      end
    end

    Minitest << Reset
  end
end
