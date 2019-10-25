# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

module OCG
  module Test
    module Validation
      NOOP_PROC = proc {}

      TYPES = [
        nil,
        1,
        1.1,
        "1",
        true,
        "a",
        :a,
        {},
        [],
        ::STDOUT,
        NOOP_PROC
      ]
      .freeze

      INVALID_HASHES = (TYPES - [{}]).freeze
      INVALID_ARRAYS = (TYPES - [[]]).freeze
    end
  end
end
