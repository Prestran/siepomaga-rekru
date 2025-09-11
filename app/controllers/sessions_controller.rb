class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: { alert: "Try again later." }, status: :bad_request }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))
    if user
      start_new_session_for user
    else
      render json: { error: "Try another email address or password." }, status: :bad_request
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
