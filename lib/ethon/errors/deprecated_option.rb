# frozen_string_literal: true
module Ethon
  module Errors

    # Raises when a deprecated option is used.
    class DeprecatedOption < EthonError
      def initialize(option)
        super("The option: #{option} is deprecated and removed from libcurl.")
      end
    end
  end
end
