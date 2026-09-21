# frozen_string_literal: true
require 'spec_helper'

describe Ethon::Multi do
  describe "#xfer_info" do
    let(:multi) { Ethon::Multi.new }

    it "responds to xfer_info" do
      expect(multi).to respond_to(:xfer_info)
    end

    it "returns a Hash" do
      expect(multi.xfer_info).to be_a(Hash)
    end

    it "includes xfers_current key when curl supports it" do
      result = multi.xfer_info
      if Ethon::Curl.curl_version_gte?("8.16.0")
        expect(result).to have_key(:xfers_current)
        expect(result[:xfers_current]).to be_a(Integer)
      else
        expect(result).to be_empty
      end
    end

    it "returns zero counters for an empty multi handle" do
      result = multi.xfer_info
      if Ethon::Curl.curl_version_gte?("8.16.0")
        expect(result[:xfers_current]).to eq(0)
        expect(result[:xfers_pending]).to eq(0)
      end
    end
  end

  describe "XFER_INFO_PARAMS" do
    it "defines the five counter constants matching CURLMINFO_XFERS_*" do
      expect(Ethon::Multi::XFER_INFO_PARAMS).to eq(
        xfers_current: 1,
        xfers_running: 2,
        xfers_pending: 3,
        xfers_done: 4,
        xfers_added: 5,
      )
    end
  end
end
