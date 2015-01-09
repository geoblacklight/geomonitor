require 'spec_helper'

describe HostsController, type: :controller do
  describe 'html' do
    it 'has a 200 status code' do
      get :show, id: 1
      expect(response.status).to eq 200
    end
  end
  describe 'json' do
    it 'has a 200 status code' do
      get :show, id: 1, format: :json
      expect(response.status).to eq 200
    end
  end
end
