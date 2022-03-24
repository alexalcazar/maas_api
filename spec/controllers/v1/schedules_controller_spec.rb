# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::SchedulesController, type: :controller) do
  before do
    Client.create!(
      name: 'SkydropX',
      requested_hours: {
        'saturday' => ['14:00-15:00', '15:00-16:00', '16:00-17:00'],
        'sunday' => ['15:00-16:00', '16:00-17:00', '18:00-19:00']
      }
    )
    User.create!(name: 'user', active: true)
  end

  let(:client_with_availables_schedules) { Client.available_schedules }

  describe 'GET #show' do
    it 'responds with the company with schedule information' do
      client_with_availables_schedules
      get :show, params: { id: Schedule.first.id }
      expect(JSON.parse(response.body)['data']).to have_key('client')
      expect(response).to have_http_status(:ok)
    end

    it 'responds with bad_request code' do
      get :show, params: { id: '' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'POST #create' do
    it 'responds with the schedule created' do
      post :create, params: { schedule: {
        client: client_with_availables_schedules[0][:name],
        week: client_with_availables_schedules[0][:available_weeks][0]
      } }
      expect(JSON.parse(response.body)['data']).to have_key('id')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT #update' do
    it 'responds ok with the available clients' do
      client_with_availables_schedules
      put :update, params: { id: Schedule.last.id, schedule: {
        'monday' => ['09:00-10:00', '10:00-11:00', '11:00-12:00'],
        'tuesday' => ['10:00-11:00', '11:00-12:00', '12:00-13:00'],
        'wednesday' => ['11:00-12:00', '12:00-13:00', '13:00-14:00'],
        'thursday' => ['12:00-13:00', '13:00-14:00', '14:00-15:00'],
        'friday' => ['13:00-14:00', '14:00-15:00', '15:00-16:00'],
        'saturday' => ['14:00-15:00', '15:00-16:00', '16:00-17:00'],
        'sunday' => ['15:00-16:00', '16:00-17:00', '18:00-19:00']
      } }
      expect(response).to have_http_status(:ok)
    end

    it 'responds with bad_request code' do
      put :update, params: { id: '', schedule: {
        'monday' => ['09:00-10:00', '10:00-11:00', '11:00-12:00'],
        'tuesday' => ['10:00-11:00', '11:00-12:00', '12:00-13:00'],
        'wednesday' => ['11:00-12:00', '12:00-13:00', '13:00-14:00'],
        'thursday' => ['12:00-13:00', '13:00-14:00', '14:00-15:00'],
        'friday' => ['13:00-14:00', '14:00-15:00', '15:00-16:00'],
        'saturday' => ['14:00-15:00', '15:00-16:00', '16:00-17:00'],
        'sunday' => ['15:00-16:00', '16:00-17:00', '18:00-19:00']
      } }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
