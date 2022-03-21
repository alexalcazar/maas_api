class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.references :client, foreign_key: true
      t.string :name
      t.json :week

      t.timestamps
    end
  end
end
