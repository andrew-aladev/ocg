# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Started < Minitest::Unit::TestCase
      def test_basic
        generator, combinations = Test.get_data
        refute generator.started?

        combinations.each do |combination|
          assert_equal generator.next, combination
          assert generator.started?
        end

        assert generator.started?
      end

      def test_after_reset
        generator, combinations = Test.get_data
        refute generator.started?

        assert_equal generator.next, combinations[0]
        assert generator.started?

        generator.reset
        refute generator.started?

        combinations.each do |combination|
          assert_equal generator.next, combination
          assert generator.started?
        end

        assert generator.started?

        generator.reset
        refute generator.started?

        combinations.each do |combination|
          assert_equal generator.next, combination
          assert generator.started?
        end

        assert generator.started?
      end
    end

    Minitest << Started
  end
end
