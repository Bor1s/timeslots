class Api::V1::TimeSlotsController < ApplicationController
  def index
    time_slots = TimeSlot.for_users(params[:users_ids]).common
    render json: time_slots
  end

  def create
    user = User.find(params[:user_id])
    # TODO: extract to service.
    time_slots_params[:time_slots].each do |pair|
      user.time_slots.create!(slot: Time.zone.parse(pair[:start])..Time.zone.parse(pair[:end]))
    end

    head :ok
  end

  private

  def time_slots_params
    params.permit(:user_id, time_slots: [:start, :end])
  end
end
