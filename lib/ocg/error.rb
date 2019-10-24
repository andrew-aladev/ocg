# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

class OCG
  class BaseError < ::StandardError; end

  class NotImplementedError < BaseError; end
  class ValidateError       < BaseError; end
end
