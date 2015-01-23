require 'spec_helper'

describe Status do
  before(:each) do
    @institution = FactoryGirl.create(
      :institution,
      name: 'Stanford University'
    )
    @host = FactoryGirl.create(
      :host,
      institution_id: @institution.id,
      name: 'Stanford',
      url: 'http://geowebservices-restricted.stanford.edu/geoserver'
    )
    @layer = FactoryGirl.create(
      :layer,
      host_id: @host.id,
      name: 'stanford-zv882px4750',
      geoserver_layername: 'druid:zv882px4750',
      access: 'Restricted',
      bbox: '73.258324 29.52631 78.859703 32.90303'
    )
    @status = FactoryGirl.create(
      :status,
      layer_id: @layer.id,
      res_code: '200',
      res_time: 0.123,
      status: 'OK',
      status_message: 'image/png',
      submitted_query: 'http://geowebservices-restricted.stanford.edu/geoserver/wms?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&LAYERS=druid%3Azv882px4750&STYLES=&SRS=EPSG%3A4326&BBOX=73.258324%2C+29.52631%2C+78.859703%2C+32.90303&WIDTH=400&HEIGHT=400&FORMAT=image%2Fpng',
      latest: true
    )
  end
  describe 'creates a status' do
    it 'with status' do
      expect(@status.status).to eq('OK')
    end
    it 'with latest' do
      expect(@status.latest).to eq(true)
    end
    it 'with host name' do
      expect(@status.layer.host.name).to eq('Stanford 1')
    end
    it 'with res_code' do
      expect(@status.res_code).to eq('200')
    end
    it 'with latest' do
      expect(@status.res_message).to eq(nil)
    end
    it 'with res_time' do
      pending('fixing ruby time')
      expect(@status.res_time).to eq(0.123)
    end
    it 'with status_message' do
      expect(@status.status_message).to eq('image/png')
    end
    it 'with submitted query' do
      expect(@status.submitted_query).to include('S&VERSION=1.1.1&REQUEST=GetMap')
    end
    it 'should have one Status' do
      expect(Status.all.count).to eq(1)
    end
  end
  describe 'checks layer status' do
    before(:each) do
      expect_any_instance_of(RestClient::Resource).to receive(:get).and_return(OpenStruct.new(headers: {content_type: 'image/png'}))
      Status.run_check(@layer)
    end
    # Run a status check on a layer

    it 'should create a new status' do
      expect(Status.all.count).to eq(2)
    end
    it 'first should be not latest' do
      expect(Status.first.latest).to eq(false)
    end
    it 'last should be latest' do
      expect(Status.last.latest).to eq(true)
    end
  end

end
