require 'spec_helper'

describe Layer do
  context 'creates a layer' do
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
    end
    it 'with host name' do
      @layer.host.name.should eq('Stanford 1')
    end
    it 'with name' do
      @layer.name.should eq('stanford-zv882px4750')
    end
    it 'with geoserver name' do
      @layer.geoserver_layername.should eq('druid:zv882px4750')
    end
    it 'with access' do
      @layer.access.should eq('Restricted')
    end
    it 'with bbox' do
      @layer.bbox.should eq('73.258324 29.52631 78.859703 32.90303')
    end
    describe 'current_status' do
      it 'returns the last status' do
        first = create(:status, layer_id: @layer.id, status: 'FAIL', latest: false)
        second = create(:status, layer_id: @layer.id, status: 'OK', latest: true)
        expect(@layer.current_status).to eq second.status
      end
    end
  end
end
