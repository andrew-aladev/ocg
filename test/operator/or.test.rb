# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "ocg"

require_relative "../common"
require_relative "../minitest"
require_relative "../validation"

class OCG
  module Test
    module Operator
      class OR < Minitest::Test
        def test_invalid
          generator = OCG.new :a => 1..2

          (Validation::INVALID_HASHES + [{}]).each do |invalid_options|
            assert_raises ValidateError do
              generator.or invalid_options
            end
          end

          (Validation::INVALID_ARRAYS + [[]]).each do |invalid_arrays|
            assert_raises ValidateError do
              generator.or :b => invalid_arrays
            end
          end
        end

        def test_basic
          generator = OCG.new(:a => 1..2).or :b => 3..4

          assert_equal({ :a => 1 }, generator.next)
          assert_equal({ :a => 2 }, generator.next)
          assert_equal({ :b => 3 }, generator.next)
          assert_equal({ :b => 4 }, generator.next)
          assert_nil generator.next
        end

        def test_after_started
          generator = OCG.new :a => 1..2
          assert_equal({ :a => 1 }, generator.next)
          assert generator.started?

          generator = generator.or :b => 3..4
          refute generator.started?

          assert_equal({ :a => 1 }, generator.next)
          assert_equal({ :a => 2 }, generator.next)
          assert_equal({ :b => 3 }, generator.next)
          assert_equal({ :b => 4 }, generator.next)
          assert_nil generator.next
        end
      end

      Minitest << OR
    end
  end
end
