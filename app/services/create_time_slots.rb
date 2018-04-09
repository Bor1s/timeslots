class CreateTimeSlots
  attr_reader :user, :params
  private :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call!
    ActiveRecord::Base.transaction do
      params[:time_slots].each do |pair|
        user.time_slots.create!(slot: pair[:start]..pair[:end])
      end
    end
  end
end
