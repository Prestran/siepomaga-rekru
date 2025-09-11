class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: { alert: "Try again later." }, status: :bad_request }

  def create
    user = User.authenticate_by(email_address: params[:email_address], password: params[:password])

    if user
      start_new_session_for user
    else
      render json: { error: "Try another email address or password." }, status: :bad_request
    end
  end
end
