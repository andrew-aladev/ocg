# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

class OCG
  module Test
    module Validation
      NOOP_PROC = proc {} # no-op

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
        NOOP_PROC
      ]
      .freeze

      INVALID_HASHES = (TYPES - [{}]).freeze
      INVALID_ARRAYS = (TYPES - [[]]).freeze
    end
  end
end
