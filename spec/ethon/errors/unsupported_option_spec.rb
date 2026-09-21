# frozen_string_literal: true
require 'spec_helper'

describe Ethon::Errors::UnsupportedOption do
  it "includes the option name and required version in the message" do
    error = Ethon::Errors::UnsupportedOption.new(:max_concurrent_streams, "7.67.0")
    expect(error.message).to include("max_concurrent_streams")
    expect(error.message).to include("7.67.0")
  end

  it "includes the current curl version in the message" do
    error = Ethon::Errors::UnsupportedOption.new(:tcp_keepcnt, "8.9.0")
    expect(error.message).to include(Ethon::Curl.curl_version_string)
  end
end
