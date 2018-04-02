class CreateTimeSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :time_slots do |t|
      t.references :user, foreign_key: true
      t.tsrange :slot, null: false

      t.timestamps
    end
  end
end
