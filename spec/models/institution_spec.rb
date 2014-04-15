require 'spec_helper'

describe Institution do
  context 'creates an institution' do
    before(:each) do
      @institution = FactoryGirl.create(
        :institution,
        name: 'Stanford University'
      )
    end

    it 'with correct name' do
      @institution.name.should eq('Stanford University')
    end
  end
end
