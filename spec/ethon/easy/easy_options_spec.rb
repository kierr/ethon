# frozen_string_literal: true
require 'spec_helper'

describe "New easy CURLOPT options" do
  let(:easy) { Ethon::Easy.new }

  [:maxage_conn, :maxlifetime_conn, :tcp_keepcnt].each do |name|
    describe "#{name} (easy option)" do
      it "is registered in easy_options" do
        expect(Ethon::Curl.easy_options(nil)).to have_key(name)
      end

      it "has type :int" do
        expect(Ethon::Curl.easy_options(nil)[name][:type]).to eq(:int)
      end
    end
  end

  describe "ssl_enable_alpn (easy option)" do
    it "is registered in easy_options" do
      expect(Ethon::Curl.easy_options(nil)).to have_key(:ssl_enable_alpn)
    end

    it "has type :bool" do
      expect(Ethon::Curl.easy_options(nil)[:ssl_enable_alpn][:type]).to eq(:bool)
    end
  end

  # The easy options module auto-generates setters from the FFI option hash.
  # Verify that Curl.set_option dispatches correctly for each new option.
  [:maxage_conn, :maxlifetime_conn, :tcp_keepcnt, :ssl_enable_alpn].each do |name|
    it "set_option accepts :#{name}" do
      expect {
        Ethon::Curl.set_option(name, 60, easy.handle)
      }.not_to raise_error
    end
  end
end
