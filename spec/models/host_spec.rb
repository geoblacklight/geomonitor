require 'spec_helper'

describe Host do
  describe 'creates a host' do
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
    end

    it 'with name' do
      expect(@host.name).to eq('Stanford 1')
    end
    it 'with institution name' do
      expect(@host.institution.name).to eq('Stanford University')
    end
  end
end
