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
          generator = OCG.new :a => 1..2

          (Validation::INVALID_HASHES + [{}]).each do |invalid_options|
            assert_raises ValidateError do
              generator.and invalid_options
            end
          end

          (Validation::INVALID_ARRAYS + [[]]).each do |invalid_arrays|
            assert_raises ValidateError do
              generator.and :b => invalid_arrays
            end
          end
        end

        def test_basic
          generator = OCG.new(:a => 1..2).and :b => 3..4

          assert_equal generator.next, :a => 1, :b => 3
          assert_equal generator.next, :a => 1, :b => 4
          assert_equal generator.next, :a => 2, :b => 3
          assert_equal generator.next, :a => 2, :b => 4
          assert generator.next.nil?
        end

        def test_after_started
          generator = OCG.new :a => 1..2
          assert_equal generator.next, :a => 1
          assert generator.started?

          generator = generator.and :b => 3..4
          refute generator.started?

          assert_equal generator.next, :a => 1, :b => 3
          assert_equal generator.next, :a => 1, :b => 4
          assert_equal generator.next, :a => 2, :b => 3
          assert_equal generator.next, :a => 2, :b => 4
          assert generator.next.nil?
        end
      end

      Minitest << AND
    end
  end
end
