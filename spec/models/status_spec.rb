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
      name: 'Stanford 1',
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
  context 'creates a status' do
    it 'with status' do
      @status.status.should eq('OK')
    end
    it 'with latest' do
      @status.latest.should eq(true)
    end
    it 'with host name' do
      @status.layer.host.name.should eq('Stanford 1')
    end
    it 'with res_code' do
      @status.res_code.should eq('200')
    end
    it 'with latest' do
      @status.res_message.should eq(nil)
    end
    it 'with res_time' do
      @status.res_time.should eq(0.123)
    end
    it 'with status_message' do
      @status.status_message.should eq('image/png')
    end
    it 'with submitted query' do
      @status.submitted_query.should include('S&VERSION=1.1.1&REQUEST=GetMap')
    end
    it 'should have one Status' do
      Status.all.count.should eq(1)
    end
  end
  context 'checks layer status' do
    before(:each) do
      Status.run_check(@layer)
    end
    # Run a status check on a layer

    it 'should create a new status' do
      Status.all.count.should eq(2)
    end
    it 'first should be not latest' do
      Status.first.latest.should eq(false)
    end
    it 'last should be latest' do
      Status.last.latest.should eq(true)
    end
  end

end
