require 'spec_helper'

describe Institution do
  describe 'creates an institution' do
    before(:each) do
      @institution = FactoryGirl.create(
        :institution,
        name: 'Stanford University'
      )
    end

    it 'with correct name' do
      expect(@institution.name).to eq('Stanford University')
    end
  end
end
