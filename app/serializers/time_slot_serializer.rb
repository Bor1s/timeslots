class TimeSlotSerializer < ActiveModel::Serializer
  attributes :id, :start, :end, :user_id

  def start
    object.slot.begin.to_s(:db)
  end

  def end
    object.slot.end.to_s(:db)
  end
end
