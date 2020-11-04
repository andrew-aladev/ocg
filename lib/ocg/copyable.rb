# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

class OCG
  module Copyable
    VARIABLES_TO_COPY = [].freeze

    def initialize_copy(source)
      self.class::VARIABLES_TO_COPY.each do |variable|
        key   = "@#{variable}".to_sym
        value = source.instance_variable_get key

        instance_variable_set key, value.dup
      end
    end
  end
end
