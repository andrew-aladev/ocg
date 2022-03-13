# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Finished < Minitest::Test
      def test_basic
        Test.get_datas do |generator, combinations|
          test_not_finished generator, combinations

          combinations.each do |combination|
            assert_equal generator.next, combination
          end

          assert_predicate generator, :finished?
        end
      end

      def test_after_reset
        Test.get_datas do |generator, combinations|
          test_not_finished generator, combinations

          test_first_option generator, combinations

          # First reset calls after first combination.
          # Second reset calls after all combinations.
          2.times do
            generator.reset
            test_not_finished generator, combinations

            combinations.each do |combination|
              assert_equal generator.next, combination
            end

            assert_predicate generator, :finished?
          end
        end
      end

      protected def test_first_option(generator, combinations)
        if combinations.empty?
          assert_nil generator.next
          assert_predicate generator, :finished?
        else
          assert_equal generator.next, combinations[0]
          refute_predicate generator, :finished?
        end
      end

      protected def test_not_finished(generator, combinations)
        if combinations.empty?
          assert_predicate generator, :finished?
        else
          refute_predicate generator, :finished?
        end
      end
    end

    Minitest << Finished
  end
end
