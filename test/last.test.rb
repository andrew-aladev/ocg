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
            assert_equal combination, generator.next
            assert_equal combination, generator.last
          end

          assert_equal combinations.last, generator.last
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
          assert generator.last.nil?

          assert_equal combinations[0], generator.next
          assert_equal combinations[0], generator.last

          generator.reset

          combinations.each do |combination|
            assert_equal combination, generator.next
            assert_equal combination, generator.last
          end

          assert_equal combinations.last, generator.last
        end
      end
    end

    Minitest << Last
  end
end
