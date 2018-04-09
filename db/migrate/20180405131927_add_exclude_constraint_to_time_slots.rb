class AddExcludeConstraintToTimeSlots < ActiveRecord::Migration[5.1]
  def self.up
    execute <<-SQL
      CREATE EXTENSION btree_gist;
    SQL

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

    execute <<-SQL
      DROP EXTENSION IF EXISTS btree_gist;
    SQL
  end
end
