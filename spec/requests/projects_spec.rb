require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  describe '#index' do
    it 'returns ok message' do
      get projects_path
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)['message']).to eq('ok')
    end
  end
end
