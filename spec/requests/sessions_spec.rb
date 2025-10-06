require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }
  let(:user1) { build(:user) }

  describe "POST /login" do
    it "logs in the user" do
      # post '/users/sign_in', params: { email: user.email, password: user.password }
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["user"]).to be_present
    end

    it "denies login with incorrect credentials" do
      # post '/users/sign_in', params: { email: user.email, password: "wrong_password" }
      sign_in user1
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
