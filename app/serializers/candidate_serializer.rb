class CandidateSerializer < ActiveModel::Serializer
  attributes :id, :email, :time_slots

  has_many :time_slots
end
