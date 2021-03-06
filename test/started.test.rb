# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Started < Minitest::Test
      def test_basic
        Test.get_datas do |generator, combinations|
          refute generator.started?

          combinations.each do |combination|
            assert_equal combination, generator.next
            assert generator.started?
          end

          assert generator.started?
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
          refute generator.started?

          assert_equal combinations[0], generator.next
          assert generator.started?

          generator.reset
          refute generator.started?

          combinations.each do |combination|
            assert_equal combination, generator.next
            assert generator.started?
          end

          assert generator.started?

          generator.reset
          refute generator.started?

          combinations.each do |combination|
            assert_equal combination, generator.next
            assert generator.started?
          end

          assert generator.started?
        end
      end
    end

    Minitest << Started
  end
end
