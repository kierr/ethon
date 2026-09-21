# frozen_string_literal: true
require 'spec_helper'

describe Ethon::Curl do
  describe "CURLINFO registrations" do
    let(:infos) { Ethon::Curl.infos }

    describe ":off_t info type" do
      it "is registered at 0x600000" do
        expect(Ethon::Curl.info_types[:off_t]).to eq(0x600000)
      end
    end

    # Verify each new CURLINFO field is registered with the correct enum value.
    # Values sourced from curl/curl.h CURLINFO_* definitions (curl 8.20.0).
    {
      proxy_error: 0x20003b,
      xfer_id: 0x60003f,
      conn_id: 0x600040,
      queue_time: 0x600041,
      used_proxy: 0x200042,
    }.each do |name, expected_value|
      describe ":#{name}" do
        it "is registered with enum value #{expected_value}" do
          expect(infos[name]).to eq(expected_value)
        end
      end
    end
  end

  describe "#get_info_off_t" do
    it "is callable as an alias for get_info_offt" do
      easy = Ethon::Easy.new
      easy.url = "http://localhost:3001"
      easy.perform
      # queue_time is an off_t field — calling the alias should not raise
      expect { easy.queue_time }.not_to raise_error
    end
  end
end
