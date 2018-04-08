class Api::V1::CandidatesController < ApplicationController
  def index
    candidates = Candidate.all
    render json: candidates
  end

  def show
    candidate = Candidate.find(params[:id])
    render json: candidate
  end

  def create
    candidate = Candidate.new(candidate_params)
    if candidate.save
      render json: candidate
    else
      render json: { errors: candidate.errors.full_messages }, status: 422
    end
  end

  def update
    candidate = Candidate.find(params[:id])
    if candidate.update_attributes(candidate_params)
      render json: candidate
    else
      render json: { errors: candidate.errors.full_messages }, status: 422
    end
  end

  def destroy
    candidate = Candidate.find(params[:id])
    candidate.destroy
    head :ok
  end

  private

  def candidate_params
    params.require(:candidate).permit(:email, :name)
  end
end
