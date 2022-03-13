# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "ocg"

require_relative "../common"
require_relative "../minitest"
require_relative "../validation"

class OCG
  module Test
    module Operator
      class MIX < Minitest::Test
        def test_invalid
          generator = OCG.new

          Validation::INVALID_HASHES.each do |invalid_options|
            assert_raises ValidateError do
              generator.mix invalid_options
            end
          end

          (Validation::INVALID_ARRAYS + [[]]).each do |invalid_arrays|
            assert_raises ValidateError do
              generator.mix :a => invalid_arrays
            end
          end
        end

        def test_basic
          generator = OCG.new(:a => 1..2).mix
          assert_equal({ :a => 1 }, generator.next)
          assert_equal({ :a => 2 }, generator.next)
          assert_nil generator.next

          generator = OCG.new.mix(:b => 3..4)
          assert_equal({ :b => 3 }, generator.next)
          assert_equal({ :b => 4 }, generator.next)
          assert_nil generator.next

          generator = OCG.new(:a => 1..2).mix :b => 3..4
          assert_equal({ :a => 1, :b => 3 }, generator.next)
          assert_equal({ :a => 2, :b => 4 }, generator.next)
          assert_nil generator.next
        end

        def test_after_started
          generator = OCG.new
          assert_nil generator.next
          refute_predicate generator, :started?

          generator = generator.mix :a => 1..2
          refute_predicate generator, :started?
          assert_equal({ :a => 1 }, generator.next)
          assert_predicate generator, :started?

          generator = generator.mix
          refute_predicate generator, :started?
          assert_equal({ :a => 1 }, generator.next)
          assert_predicate generator, :started?

          generator = generator.mix :b => 3..4
          refute_predicate generator, :started?
          assert_equal({ :a => 1, :b => 3 }, generator.next)
          assert_equal({ :a => 2, :b => 4 }, generator.next)
          assert_nil generator.next
        end

        def test_different_length
          generator = OCG.new(:a => 1..2).mix :b => 3..5
          assert_equal({ :a => 1, :b => 3 }, generator.next)
          assert_equal({ :a => 2, :b => 4 }, generator.next)
          assert_equal({ :a => 1, :b => 5 }, generator.next)
          assert_nil generator.next

          generator = OCG.new(:a => 1..3).mix :b => 4..5
          assert_equal({ :a => 1, :b => 4 }, generator.next)
          assert_equal({ :a => 2, :b => 5 }, generator.next)
          assert_equal({ :a => 3, :b => 4 }, generator.next)
          assert_nil generator.next
        end
      end

      Minitest << MIX
    end
  end
end
