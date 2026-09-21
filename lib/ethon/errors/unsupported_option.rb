# frozen_string_literal: true
module Ethon
  module Errors
    class UnsupportedOption < EthonError
      def initialize(option, required_version)
        super("The option: #{option} requires libcurl >= #{required_version}. " \
              "Current version: #{Ethon::Curl.curl_version_string}.")
      end
    end
  end
end
