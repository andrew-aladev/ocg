# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require_relative "helper"
require_relative "common"
require_relative "minitest"

class OCG
  module Test
    class Length < Minitest::Test
      def test_length
        Test.get_datas do |generator, combinations|
          assert_equal generator.length, combinations.length
        end
      end
    end

    Minitest << Length
  end
end
