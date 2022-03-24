# frozen_string_literal: true

module V1
  class SchedulesController < ApplicationController
    def show
      schedule = Schedule.find_by(id: params[:id])
      if schedule.present?
        users = User.where(active: true)
        render json: { data: { schedule: schedule, client: schedule.client.name, users: users } }, status: :ok
      else
        render json: { data: {} }, status: :bad_request
      end
    end

    def create
      schedule = Schedule.data(create_schedule_params[:client], create_schedule_params[:week])
      render json: { data: schedule }, status: :ok
    end

    def update
      schedule = Schedule.find_by(id: params[:id])
      if schedule.present?
        schedule.update(week: update_schedule_params)
        render json: { data: update_schedule_params }, status: :ok
      else
        render json: { data: {} }, status: :bad_request
      end
    end

    private

    def create_schedule_params
      params.require(:schedule).permit(
        :client,
        :week
      )
    end

    def update_schedule_params
      params.require(:schedule).permit(
        monday: {},
        tuesday: {},
        wednesday: {},
        thursday: {},
        friday: {},
        saturday: {},
        sunday: {}
      )
    end
  end
end
