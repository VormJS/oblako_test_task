require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let!(:projects) do
    create_list(:project, 7) do |project|
      create_list :todo, 4, project: project
    end
  end
  describe '#index' do
    before { get '/projects' }
    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
    it 'returns json' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
    it 'returns all projects' do
      expect(json.size).to eq(7)
    end
    it 'returns projects with todos' do
      expect(json.first['todos'].size).to eq(4)
    end
  end
end
