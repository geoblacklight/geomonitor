require 'spec_helper'

describe Geomonitor::Response do
  let(:response) { double('response') }
  let(:ab_response) { double('ab_response') }
  let(:normal_response) { Geomonitor::Response.new(response) }
  let(:abnormal_response) { Geomonitor::Response.new(ab_response) }
  before do
    allow(response).to receive(:headers).and_return(content_type: 'image/png')
    allow(response).to receive(:status).and_return(200)
    allow(response).to receive(:body).and_return({})
    allow(ab_response).to receive(:headers).and_return(content_type: 'application/xml')
    allow(ab_response).to receive(:status).and_return(200)
    allow(ab_response).to receive(:body).and_return(nil)
  end
  describe 'initialize' do
    it 'is an Geomonitor::Response' do
      expect(normal_response).to be_an Geomonitor::Response
    end
  end
  describe 'is_an_exception?' do
    let(:exception) { Geomonitor::Exceptions::TileGrabFailed.new() }
    let(:exception_response) { Geomonitor::Response.new(exception) }
    it 'true for an exception' do
      expect(exception_response.is_an_exception?).to be_truthy
    end
    it 'false for anything else' do
      expect(normal_response.is_an_exception?).to be_falsey
    end
  end
  describe 'parse_response' do
    let(:exception) { Geomonitor::Exceptions::TileGrabFailed.new() }
    let(:exception_response) { Geomonitor::Response.new(exception) }
    it 'for a failed response' do
      expect(exception_response.body).to eq 'Request Timeout'
    end
    it 'for an OK response' do
      expect(normal_response.body).to eq 'image/png'
      expect(normal_response.response_code).to eq 200
      expect(normal_response.status).to eq 'OK'
    end
    it 'for something went wrong response' do
      expect(abnormal_response.body).to be_nil
      expect(abnormal_response.response_code).to eq 200
      expect(abnormal_response.status).to eq '??'
    end
  end
end
