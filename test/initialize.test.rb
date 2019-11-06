# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "ocg"

require_relative "minitest"
require_relative "validation"

class OCG
  module Test
    class Initialize < Minitest::Test
      def test_invalid
        (Validation::INVALID_HASHES + [{}]).each do |invalid_options|
          assert_raises ValidateError do
            OCG.new invalid_options
          end
        end

        (Validation::INVALID_ARRAYS + [[]]).each do |invalid_arrays|
          assert_raises ValidateError do
            OCG.new :a => invalid_arrays
          end
        end
      end

      def test_basic
        generator = OCG.new :a => 1..2

        assert_equal generator.next, :a => 1
        assert_equal generator.next, :a => 2
        assert generator.next.nil?
      end
    end

    Minitest << Initialize
  end
end
