class Api::V1::CandidatesController < ApplicationController
  def index
  end

  def show
  end

  def create
    candidate = Candidate.new(user_params)
    if candidate.save
      render json: candidate
    else
      render json: { errors: candidate.errors.full_messages}
    end
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.permit(:email)
  end
end
