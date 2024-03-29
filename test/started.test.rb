# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Started < Minitest::Test
      def test_basic
        Test.get_datas do |generator, combinations|
          refute_predicate generator, :started?

          combinations.each do |combination|
            assert_equal generator.next, combination
            test_started generator, combinations
          end

          test_started generator, combinations
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
          refute_predicate generator, :started?

          test_first_option generator, combinations

          # First reset calls after first combination.
          # Second reset calls after all combinations.
          2.times do
            generator.reset
            refute_predicate generator, :started?

            combinations.each do |combination|
              assert_equal generator.next, combination
              test_started generator, combinations
            end

            test_started generator, combinations
          end
        end
      end

      protected def test_started(generator, combinations)
        if combinations.empty?
          refute_predicate generator, :started?
        else
          assert_predicate generator, :started?
        end
      end

      protected def test_first_option(generator, combinations)
        if combinations.empty?
          assert_nil generator.next
          refute_predicate generator, :started?
        else
          assert_equal generator.next, combinations[0]
          assert_predicate generator, :started?
        end
      end
    end

    Minitest << Started
  end
end
