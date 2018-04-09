class Api::V1::TimeSlotsController < ApplicationController
  def index
    # Refactor all of this!
    time_slots = TimeSlot.for_users(user_ids_params).common
    common_time_slots = []

    if (user_ids_params.map(&:to_i) - time_slots.map(&:user_id).uniq).empty? # Do we have common time slots for all input users?
      group = time_slots.group_by {|i| i.user_id }.sort_by { |group_key, group_slots| group_slots.size }

      # Create array of first taken timeslots from each group
      first_group = group.shift
      first_group.last.each do |first_group_time_slots|
        slots = []
        slots << first_group_time_slots
        group.each do |group, time_slots|
          slots << time_slots.shift
        end

        # Finding overlap between time slots
        min = Float::INFINITY
        sorted_slots = slots.map(&:slot).sort { |a,b| a.begin <=> b.begin }
        max_range_start_point = sorted_slots.last
        sorted_slots.each do |slot|
          if slot.end < min && slot.end > max_range_start_point.begin
            min = slot.end
          end
        end

        unless min.is_a?(Float) # Check whether this is still an Infinity
          common_time_slots << TimeSlotShortSerializer.new(TimeSlot.new(slot: max_range_start_point.begin..min)).as_json
        end
      end

      if common_time_slots.empty?
        render json: { error: "No common time slots found for users: #{user_ids_params.join(',')}"}
      else
        render json: common_time_slots
      end
    else
      render json: { error: "No common time slots found for users: #{user_ids_params.join(',')}"}
    end
  end

  def create
    user = User.find(time_slots_params[:user_id])
    # TODO: extract to service.
    ActiveRecord::Base.transaction do
      time_slots_params[:time_slots].each do |pair|
        user.time_slots.create!(slot: pair[:start]..pair[:end])
      end
    end

    render json: user
  end

  def destroy
    time_slot = TimeSlot.find(params[:id])
    time_slot.destroy
    head :ok
  end

  private

  def user_ids_params
    params.require(:user_ids)
  end

  def time_slots_params
    params.permit(:user_id, time_slots: [:start, :end])
  end
end
