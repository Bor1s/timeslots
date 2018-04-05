class Api::V1::TimeSlotsController < ApplicationController
  def index
    time_slots = TimeSlot.for_users(params[:user_ids]).common

    if (time_slots.map(&:user_id).uniq - params[:user_ids]).empty? # Do we have common time slots for all input users?
      group = time_slots.group_by {|i| i.slot.begin.to_date}

      common_time_slots = []
      group.each do |group, time_slots|
        min = Float::INFINITY
        slots = time_slots.map(&:slot)
        sorted_slots = slots.sort {|a,b| a.begin <=> b.begin }
        max_range_start_point = sorted_slots.last
        sorted_slots.each do |slot|
          if slot.end < min && slot.end > max_range_start_point.begin
            min = slot.end
          end
        end

        if min.is_a?(Float) # Check whether this is still an Infinity
          render json: { error: "No common time slots found for people #{params[:user_ids]}"} and return
        else
          common_time_slots << TimeSlot.new(slot: max_range_start_point.begin..min)
        end
      end

      render json: common_time_slots

    else
      render json: { error: "No common time slots found for people #{params[:user_ids]}"}
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

  def time_slots_params
    params.permit(:user_id, time_slots: [:start, :end])
  end
end