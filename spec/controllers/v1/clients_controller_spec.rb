# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::ClientsController, type: :controller) do
  before do
    Client.create!(
      name: 'SkydropX',
      requested_hours: {
        'saturday' => ['14:00-15:00', '15:00-16:00', '16:00-17:00'],
        'sunday' => ['15:00-16:00', '16:00-17:00', '18:00-19:00']
      }
    )
  end

  describe 'GET #show' do
    it 'responds with the available clients' do
      get :show
      expect(JSON.parse(response.body)['data'].length).to eq(1)
      expect(response).to have_http_status(:ok)
    end
  end
end
