class User < ApplicationRecord
  has_many :time_slots, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
