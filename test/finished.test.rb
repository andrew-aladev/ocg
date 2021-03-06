# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Finished < Minitest::Test
      def test_basic
        Test.get_datas do |generator, combinations|
          refute generator.finished?

          combinations.each do |combination|
            assert_equal combination, generator.next
          end

          assert generator.finished?
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
          refute generator.finished?

          assert_equal combinations[0], generator.next
          refute generator.finished?

          generator.reset
          refute generator.finished?

          combinations.each do |combination|
            assert_equal combination, generator.next
          end

          assert generator.finished?

          generator.reset
          refute generator.finished?

          combinations.each do |combination|
            assert_equal combination, generator.next
          end

          assert generator.finished?
        end
      end
    end

    Minitest << Finished
  end
end
