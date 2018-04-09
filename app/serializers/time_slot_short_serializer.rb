class TimeSlotShortSerializer < ActiveModel::Serializer
  attributes :start, :end

  def start
    object.slot.begin.to_s(:db)
  end

  def end
    object.slot.end.to_s(:db)
  end
end
