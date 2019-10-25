# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Finished < Minitest::Unit::TestCase
      def test_basic
        generator, combinations = Test.get_data
        refute generator.finished?

        combinations.each do |combination|
          assert_equal generator.next, combination
        end

        assert generator.finished?
      end

      def test_after_reset
        generator, combinations = Test.get_data
        refute generator.finished?

        assert_equal generator.next, combinations[0]
        refute generator.finished?

        generator.reset
        refute generator.finished?

        combinations.each do |combination|
          assert_equal generator.next, combination
        end

        assert generator.finished?

        generator.reset
        refute generator.finished?

        combinations.each do |combination|
          assert_equal generator.next, combination
        end

        assert generator.finished?
      end
    end

    Minitest << Finished
  end
end
