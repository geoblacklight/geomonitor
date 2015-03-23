require 'spec_helper'

describe Geomonitor::Client do
  let(:host) { create(:host, url: 'http://www.example.com/geoserver') }
  let(:layer) { create(
    :layer,
    host_id: host.id,
    name: 'stanford-zv882px4750',
    geoserver_layername: 'druid:zv882px4750',
    access: 'Restricted',
    bbox: '73.258324 29.52631 78.859703 32.90303'
    )
  }
  let(:client) { Geomonitor::Client.new(layer) }
  describe 'intialize' do
    it 'is a Geomonitor::Client' do
      expect(client).to be_an Geomonitor::Client
    end
  end
  describe 'request_params' do
    it 'includes geoserver_layername' do
      expect(client.request_params).to include 'LAYERS' => 'druid:zv882px4750'
    end
    it 'includes a formatted bbox tile request' do
      expect(client.request_params).to include 'BBOX' => '8140237.7642581295,3443946.7464169012,8453323.832114212,3757032.814272983'
    end
    it 'includes other static params' do
      expect(client.request_params).to include(
        'SERVICE' => 'WMS',
        'VERSION' => '1.1.1',
        'REQUEST' => 'GetMap',
        'STYLES' => '',
        'CRS' => 'EPSG:900913',
        'SRS' => 'EPSG:3857',
        'WIDTH' => '256',
        'HEIGHT' => '256',
        'FORMAT' => 'image/png',
        'TILED' => true
      )
    end
  end
  describe 'url' do
    it 'adds /wms to host url' do
      expect(client.url).to eq 'http://www.example.com/geoserver/wms'
    end
  end
  describe 'create_response' do
    it 'kicks off and ends timers' do
      expect(client.elapsed_time).to be_nil
      client.create_response
      expect(client.elapsed_time).to_not be_nil
    end
    it 'creates a Geomonitor::Response' do
      expect(client.create_response).to be_an Geomonitor::Response
    end
  end
  describe 'grab_tile' do
    let(:response) { double('response') }
    let(:get) { double('get') }
    it 'request tile from server' do
      expect(response).to receive(:get).and_return(get)
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/geoserver/wms').and_return(response)
      client.grab_tile
    end
    it 'raises a Geomonitor::Exceptions::TileGrabFailed when Faraday ConnentionFailed' do
      expect(response).to receive(:url_prefix).and_return 'http://www.example.com/geoserver/wms'
      expect(response).to receive(:get).and_raise(Faraday::Error::ConnectionFailed.new('Failed'))
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/geoserver/wms').and_return(response)
      expect { client.grab_tile }.to raise_error(Geomonitor::Exceptions::TileGrabFailed)
    end
    it 'raises a Geomonitor::Exceptions::TileGrabFailed when Faraday TimeoutError' do
      expect(response).to receive(:url_prefix).and_return 'http://www.example.com/geoserver/wms'
      expect(response).to receive(:get).and_raise(Faraday::Error::TimeoutError.new('Failed'))
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/geoserver/wms').and_return(response)
      expect { client.grab_tile }.to raise_error(Geomonitor::Exceptions::TileGrabFailed)
    end
  end
  describe 'elapsed_time' do
    it 'without start_time or end_time' do
      expect(client.elapsed_time).to be_nil
      client.start_time = Time.now
      expect(client.elapsed_time).to be_nil
      client.start_time = nil
      client.end_time = Time.now
      expect(client.elapsed_time).to be_nil
    end
    it 'calculates the elapsed time in seconds' do
      client.start_time = Time.new(2013)
      client.end_time = Time.new(2014)
      SECONDS_IN_A_YEAR = 315_360_00
      expect(client.elapsed_time).to eq SECONDS_IN_A_YEAR
    end
  end
end
