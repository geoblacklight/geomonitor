require 'spec_helper'

describe Layer do
  describe 'creates a layer' do
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
      expect(@layer.host.name).to eq('Stanford 1')
    end
    it 'with name' do
      expect(@layer.name).to eq('stanford-zv882px4750')
    end
    it 'with geoserver name' do
      expect(@layer.geoserver_layername).to eq('druid:zv882px4750')
    end
    it 'with access' do
      expect(@layer.access).to eq('Restricted')
    end
    it 'with bbox' do
      expect(@layer.bbox).to eq('73.258324 29.52631 78.859703 32.90303')
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
