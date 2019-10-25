# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "ocg"

require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Length < Minitest::Unit::TestCase
      def test_length
        generator, combinations = Test.get_data
        assert_equal generator.length, combinations.length
      end
    end

    Minitest << Length
  end
end
