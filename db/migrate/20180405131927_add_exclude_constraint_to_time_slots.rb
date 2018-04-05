class AddExcludeConstraintToTimeSlots < ActiveRecord::Migration[5.1]
  def self.up
    execute <<-SQL
      ALTER TABLE time_slots
        add constraint unique_slot
        EXCLUDE USING GIST (
          user_id WITH =,
          slot WITH &&
        )
    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE time_slots
        drop constraint unique_slot
    SQL
  end
end
