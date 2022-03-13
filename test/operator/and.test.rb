# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "ocg"

require_relative "../common"
require_relative "../minitest"
require_relative "../validation"

class OCG
  module Test
    module Operator
      class AND < Minitest::Test
        def test_invalid
          generator = OCG.new

          Validation::INVALID_HASHES.each do |invalid_options|
            assert_raises ValidateError do
              generator.and invalid_options
            end
          end

          (Validation::INVALID_ARRAYS + [[]]).each do |invalid_arrays|
            assert_raises ValidateError do
              generator.and :a => invalid_arrays
            end
          end
        end

        def test_basic
          generator = OCG.new(:a => 1..2).and
          assert_equal({ :a => 1 }, generator.next)
          assert_equal({ :a => 2 }, generator.next)
          assert_nil generator.next

          generator = OCG.new.and(:b => 3..4)
          assert_equal({ :b => 3 }, generator.next)
          assert_equal({ :b => 4 }, generator.next)
          assert_nil generator.next

          generator = OCG.new(:a => 1..2).and :b => 3..4
          assert_equal({ :a => 1, :b => 3 }, generator.next)
          assert_equal({ :a => 1, :b => 4 }, generator.next)
          assert_equal({ :a => 2, :b => 3 }, generator.next)
          assert_equal({ :a => 2, :b => 4 }, generator.next)
          assert_nil generator.next
        end

        def test_after_started
          generator = OCG.new
          assert_nil generator.next
          refute_predicate generator, :started?

          generator = generator.and :a => 1..2
          refute_predicate generator, :started?
          assert_equal({ :a => 1 }, generator.next)
          assert_predicate generator, :started?

          generator = generator.and
          refute_predicate generator, :started?
          assert_equal({ :a => 1 }, generator.next)
          assert_predicate generator, :started?

          generator = generator.and :b => 3..4
          refute_predicate generator, :started?
          assert_equal({ :a => 1, :b => 3 }, generator.next)
          assert_equal({ :a => 1, :b => 4 }, generator.next)
          assert_equal({ :a => 2, :b => 3 }, generator.next)
          assert_equal({ :a => 2, :b => 4 }, generator.next)
          assert_nil generator.next
        end
      end

      Minitest << AND
    end
  end
end
