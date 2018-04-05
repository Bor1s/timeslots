class TimeSlot < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :slot, presence: true, uniqueness: { scope: :user_id }
  # TODO: Create slot date format validator.

  scope :for_users, -> (ids) { where(user_id: ids) }
  scope :common, -> { joins("INNER JOIN #{self.table_name} ts2 ON ts2.slot && time_slots.slot AND ts2.id != time_slots.id").group(:id) }
end
