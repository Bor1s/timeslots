class Employee < User
  validates :email, presence: true, uniqueness: true
end
