class Api::V1::TimeSlotsController < ApplicationController
  before_action :check_user_ids, only: [:index]

  def index
    time_slots = TimeSlot.for_users(user_ids_params).common
    if any_common_time_slots_for_given_users?(user_ids_params, time_slots)
      service = FindCommonAvailableTime.new(time_slots, params: user_ids_params)
      service.call
      render json: service.result, status: service.status
    else
      render json: { error: "No common time slots found for users: #{user_ids_params.join(',')}" }
    end
  end

  def create
    user = User.find(time_slots_params[:user_id])
    CreateTimeSlots.new(user, time_slots_params).call!

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

  def any_common_time_slots_for_given_users?(user_ids, time_slots)
    (user_ids.map(&:to_i) - time_slots.map(&:user_id).uniq).empty?
  end

  def check_user_ids
    return true if user_ids_params.size > 1
    render json: { error: 'Please provide more than one user to find common time slots.' }
  end
end
