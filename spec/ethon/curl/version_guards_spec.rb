# frozen_string_literal: true
require 'spec_helper'

describe Ethon::Curl do
  describe ".curl_version_string" do
    it "returns a version string matching X.Y.Z" do
      expect(Ethon::Curl.curl_version_string).to match(/\A\d+\.\d+\.\d+\z/)
    end
  end

  describe ".curl_version_gte?" do
    it "returns true for a version lower than current" do
      expect(Ethon::Curl.curl_version_gte?("0.1.0")).to be true
    end

    it "returns true for the exact current version" do
      expect(Ethon::Curl.curl_version_gte?(Ethon::Curl.curl_version_string)).to be true
    end

    it "returns false for a version higher than current" do
      major, minor, patch = Ethon::Curl.curl_version_string.split(".").map(&:to_i)
      future = "#{major}.#{minor + 100}.#{patch}"
      expect(Ethon::Curl.curl_version_gte?(future)).to be false
    end
  end

  describe ".supports?" do
    it "returns true for options not in MINIMUM_CURL_VERSIONS" do
      expect(Ethon::Curl.supports?(:verbose)).to be true
    end

    it "returns true for versioned options supported by current curl" do
      if Ethon::Curl.curl_version_gte?("7.67.0")
        expect(Ethon::Curl.supports?(:max_concurrent_streams)).to be true
      end
    end

    it "returns false for versioned options not yet available" do
      version = Ethon::Curls::Options::MINIMUM_CURL_VERSIONS[:max_concurrent_streams]
      unless Ethon::Curl.curl_version_gte?(version)
        expect(Ethon::Curl.supports?(:max_concurrent_streams)).to be false
      end
    end
  end
end
