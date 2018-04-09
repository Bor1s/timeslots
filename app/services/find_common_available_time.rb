class FindCommonAvailableTime
  attr_reader :time_slots, :params, :common_time_slots, :result, :status
  private :time_slots, :params, :common_time_slots

  def initialize(time_slots, params: {})
    @time_slots = time_slots
    @params = params
    @common_time_slots = []
    @result = nil
    @status = 200
  end

  def call
    # Grouping slots by user_id and sorting groups by ASC amount of time slots
    group = time_slots.group_by {|i| i.user_id }.sort_by { |group_key, group_slots| group_slots.size }
    @common_time_slots = take_first_timeslots_from_each_group(group)

    if common_time_slots.empty?
      @result = { error: "No common time slots found for users: #{params.join(',')}"}
      @status = 500
    else
      @result = common_time_slots
    end
  end

  private

  def take_first_timeslots_from_each_group(group)
    first_group = group.shift
    first_group.last.map do |first_group_time_slots|
      slots = [first_group_time_slots]
      group.each do |group, time_slots|
        slots << time_slots.shift
      end

      TimeSlotShortSerializer.new(TimeSlot.new(slot: minimal_overlapping_time(slots))).as_json
    end
  end

  def minimal_overlapping_time(slots, min = Float::INFINITY)
    sorted_slots = slots.map(&:slot).sort { |a,b| a.begin <=> b.begin }
    sorted_slots.each do |slot|
      min = slot.end if within_time_range_extremes?(min, slot, sorted_slots.last)
    end

    sorted_slots.last.begin..min unless still_infinity?(min)
  end

  def within_time_range_extremes?(min, slot, max_slot_start_time)
    slot.end < min && slot.end > max_slot_start_time.begin
  end

  def still_infinity?(time)
    time.is_a?(Float)
  end
end
