require 'spec_helper'

describe Host do
  context 'creates a host' do
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
    end

    it 'with name' do
      @host.name.should eq('Stanford 1')
    end
    it 'with institution name' do
      @host.institution.name.should eq('Stanford University')
    end
  end
end
