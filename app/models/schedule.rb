# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :client

  def self.data(client, week)
    schedule = Schedule.joins(:client).find_by(clients: { name: client }, name: week)
    return {} unless schedule.present?

    return {} unless schedule.week.present?

    optimal_schedule = schedule.best_schedule_algorithm
    {
      id: schedule.id, week: optimal_schedule,
      information: schedule.total_hours_asigned_by_employee(optimal_schedule)
    }
  end

  def best_schedule_algorithm
    final_schedule = {}
    users_with_availables_hours = create_users_with_available_hours_hash
    week.each do |day, hours|
      final_schedule[day] = {}
      hours.each do |hour, available_ids_to_select|
        result = employee_with_more_available_hours(available_ids_to_select, users_with_availables_hours)
        users_with_availables_hours = result[:users_with_availables_hours]
        next final_schedule[day][hour] = '' if available_ids_to_select.empty?

        final_schedule[day][hour] = result[:selected_user][:id]
      end
    end
    final_schedule
  end

  def total_hours_asigned_by_employee(optimal_schedule)
    count_record = create_counter_total_assigend_hours
    optimal_schedule.each do |_day, hours|
      hours.each do |_key, value|
        selected = count_record.find { |user| user[:id] == value }
        selected = count_record.find { |user| user[:name] == 'Sin asignar' } if selected.nil?
        selected[:total] += 1
      end
    end
    count_record
  end

  private

  def create_counter_total_assigend_hours
    users = User.where(active: true).map { |user| { id: user.id, name: user.name, total: 0 } }
    users.push({ name: 'Sin asignar', total: 0 })
  end

  def create_users_with_available_hours_hash
    users = User.where(active: true)
    total_hours = total_available_hours_in_schedule
    users.map do |user|
      { id: user.id, available_hours: (total_hours / users.length), selected: false }
    end
  end

  def total_available_hours_in_schedule
    count = 0
    week.each do |_day, hours|
      hours.each do |_key, _value|
        count += 1
      end
    end
    count
  end

  def employee_with_more_available_hours(available_ids_to_select, users_with_availables_hours)
    if available_ids_to_select.empty?
      selected_user = users_with_availables_hours.max_by { |user| user[:available_hours] }
    else
      available_ids_to_select_with_available_hours = users_with_availables_hours.filter do |user|
        available_ids_to_select.include?(user[:id].to_s)
      end
      selected_user = search_user_with_selected_flag(available_ids_to_select_with_available_hours)
    end
    users_with_availables_hours = update_available_hours_and_selected(users_with_availables_hours, selected_user)
    { selected_user: selected_user,  users_with_availables_hours: users_with_availables_hours }
  end

  def update_available_hours_and_selected(users_with_availables_hours, selected_user)
    users_with_availables_hours.each do |user|
      if user[:id] == selected_user[:id]
        user[:available_hours] -= 1
        user[:selected] = true
      else
        user[:selected] = false
      end
    end
    users_with_availables_hours
  end

  def search_user_with_selected_flag(available_ids_to_select_with_available_hours)
    selected_before = available_ids_to_select_with_available_hours.find { |id_with_hours| id_with_hours[:selected] }
    if selected_before.nil? || selected_before[:available_hours].zero?
      selected_before = available_ids_to_select_with_available_hours.max_by { |user| user[:available_hours] }
    end
    selected_before
  end

  def counter_hours_by_id(id, optimal_schedule)
    count = 0
    optimal_schedule.each do |_day, hours|
      hours.each do |_key, value|
        next if value.empty?

        count += 1 if value.include?(id.to_s)
      end
    end
    count
  end

  def counter_empty
    count = 0
    week.each do |_day, hours|
      hours.each { |_key, value| count += 1 if value.empty? }
    end
    count
  end
end
