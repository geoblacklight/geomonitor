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
  context 'creates a ping' do
    it 'with status' do
      @ping.status.should eq(true)
    end
    it 'with latest' do
      @ping.latest.should eq(true)
    end
    it 'with host name' do
      @ping.host.name.should eq('Stanford 1')
    end
    it 'should have one Ping' do
      Ping.all().count.should eq(1)
    end
  end
  context 'checks host ping' do
    before(:each) do
      Ping.check_status(@host)
    end
    it 'should create a new ping' do
      Ping.all().count.should eq(2)
    end
    it 'first should be not latest' do
      Ping.first.latest.should eq(false)
    end
    it 'last should be latest' do
      Ping.last.latest.should eq(true)
    end
  end
end
