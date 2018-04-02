class Api::V1::UsersController < ApplicationController
  respond_to :json

  def index
  end

  def show
  end

  def create
    user = User.create(user_params)
    respond_with user
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
