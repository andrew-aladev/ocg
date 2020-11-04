# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Copy < Minitest::Test
      def test_basic
        Test.get_datas do |generator, combinations|
          generator_copy = generator.dup

          assert generator.last.nil?
          refute generator.started?
          refute generator.finished?

          assert generator_copy.last.nil?
          refute generator_copy.started?
          refute generator_copy.finished?

          first_combination = combinations[0]

          # Reading first combination from initial generator.

          assert_equal generator.next, first_combination
          assert_equal generator.last, first_combination
          assert generator.started?
          refute generator.finished?

          assert generator_copy.last.nil?
          refute generator_copy.started?
          refute generator_copy.finished?

          # Reading first combination from generator copy.

          assert_equal generator_copy.next, first_combination
          assert_equal generator_copy.last, first_combination
          assert generator_copy.started?
          refute generator_copy.finished?

          assert_equal generator.last, first_combination
          assert generator.started?
          refute generator.finished?
        end
      end
    end

    Minitest << Copy
  end
end
