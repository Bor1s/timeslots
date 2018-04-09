class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :error
  rescue_from ActiveRecord::StatementInvalid, with: :error

  private

  def not_found
    render json: { error: 'There is no such resource around!' }, status: :not_found
  end

  def error(exception)
    render json: { error: exception.message }, status: 500
  end
end
