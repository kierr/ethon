# frozen_string_literal: true
require 'spec_helper'

describe Ethon::Easy::Informations do
  let(:easy) { Ethon::Easy.new }

  before do
    easy.url = "http://localhost:3001"
    easy.perform
  end

  # New :off_t fields should return Integer after a request.
  {
    queue_time: Integer,
    posttransfer_time: Integer,
    earlydata_sent: Integer,
    conn_id: Integer,
    xfer_id: Integer,
    size_delivered: Integer,
  }.each do |name, expected_type|
    describe "##{name}" do
      it "returns #{expected_type}" do
        expect(easy.send(name)).to be_a(expected_type)
      end
    end
  end

  # New :long fields should return Integer after a request.
  {
    used_proxy: Integer,
    proxy_error: Integer,
  }.each do |name, expected_type|
    describe "##{name}" do
      it "returns #{expected_type}" do
        expect(easy.send(name)).to be_a(expected_type)
      end
    end
  end

  # used_proxy should be 0 for a direct request (no proxy).
  describe "#used_proxy" do
    it "returns 0 for direct requests" do
      expect(easy.used_proxy).to eq(0)
    end
  end

  # conn_id and xfer_id should be non-negative.
  describe "#conn_id" do
    it "is non-negative" do
      expect(easy.conn_id).to be >= 0
    end
  end

  describe "#xfer_id" do
    it "is non-negative" do
      expect(easy.xfer_id).to be >= 0
    end
  end
end
