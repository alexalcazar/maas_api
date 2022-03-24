# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :schedules

  validates :name, :requested_hours, presence: { message: + '%{attribute} no puede estar en blanco' }

  def self.available_schedules
    all.map do |client|
      {
        id: client.id,
        name: client.name,
        available_weeks: client.available_weeks
      }
    end
  end

  def available_weeks
    actual_week = Time.now.strftime('%U').to_i
    validate_weeks(actual_week)
    schedules.pluck(:name)
  end

  private

  def validate_weeks(actual_week)
    existing = schedules.pluck(:name)
    5.times do
      unless existing.include?("Semana #{actual_week}")
        schedules << Schedule.new(name: "Semana #{actual_week}", week: week_hash(requested_hours))
      end
      actual_week += 1
    end
  end

  def week_hash(data)
    week = {}
    data.each do |day, hours|
      week[day] = {}
      hours.each do |hour|
        week[day][hour] = []
      end
    end
    week
  end
end
