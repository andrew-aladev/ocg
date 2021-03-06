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
          generator = OCG.new :a => 1..2

          (Validation::INVALID_HASHES + [{}]).each do |invalid_options|
            assert_raises ValidateError do
              generator.mix invalid_options
            end
          end

          (Validation::INVALID_ARRAYS + [[]]).each do |invalid_arrays|
            assert_raises ValidateError do
              generator.mix :b => invalid_arrays
            end
          end
        end

        def test_basic
          generator = OCG.new(:a => 1..2).mix :b => 3..4

          assert_equal({ :a => 1, :b => 3 }, generator.next)
          assert_equal({ :a => 2, :b => 4 }, generator.next)
          assert generator.next.nil?
        end

        def test_after_started
          generator = OCG.new :a => 1..2
          assert_equal({ :a => 1 }, generator.next)
          assert generator.started?

          generator = generator.mix :b => 3..4
          refute generator.started?

          assert_equal({ :a => 1, :b => 3 }, generator.next)
          assert_equal({ :a => 2, :b => 4 }, generator.next)
          assert generator.next.nil?
        end

        def test_different_length
          generator = OCG.new(:a => 1..2).mix :b => 3..5

          assert_equal({ :a => 1, :b => 3 }, generator.next)
          assert_equal({ :a => 2, :b => 4 }, generator.next)
          assert_equal({ :a => 1, :b => 5 }, generator.next)
          assert generator.next.nil?

          generator = OCG.new(:a => 1..3).mix :b => 4..5

          assert_equal({ :a => 1, :b => 4 }, generator.next)
          assert_equal({ :a => 2, :b => 5 }, generator.next)
          assert_equal({ :a => 3, :b => 4 }, generator.next)
          assert generator.next.nil?
        end
      end

      Minitest << MIX
    end
  end
end
