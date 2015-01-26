require 'spec_helper'

describe Ping do
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
    @ping = FactoryGirl.create(
      :ping,
      host_id: @host.id,
      status: true,
      latest: true
    )
  end
  describe 'creates a ping' do
    it 'with status' do
      expect(@ping.status).to eq(true)
    end
    it 'with latest' do
      expect(@ping.latest).to eq(true)
    end
    it 'with host name' do
      expect(@ping.host.name).to eq('Stanford 1')
    end
    it 'should have one Ping' do
      expect(Ping.all().count).to eq(1)
    end
  end
  describe 'checks host ping' do
    before(:each) do
      Ping.check_status(@host)
    end
    it 'should create a new ping' do
      expect(Ping.all().count).to eq(2)
    end
    it 'first should be not latest' do
      expect(Ping.first.latest).to eq(false)
    end
    it 'last should be latest' do
      expect(Ping.last.latest).to eq(true)
    end
  end
end
