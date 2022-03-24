# frozen_string_literal: true

module V1
  class ClientsController < ApplicationController
    def show
      clients_with_available_weeks = Client.available_schedules
      render json: { data: clients_with_available_weeks }, status: :ok
    end
  end
end
