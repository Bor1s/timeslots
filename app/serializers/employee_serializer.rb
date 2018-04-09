class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :time_slots

  has_many :time_slots
end
