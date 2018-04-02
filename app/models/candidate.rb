class Candidate < User
  validates :email, presence: true, uniqueness: true
end
