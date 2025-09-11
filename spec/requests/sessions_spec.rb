require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { User.create(email_address: "jan@example.com", password: "abc") }
  describe "POST /session" do

    it "returns http success" do
      post "/session", params: { email_address: user.email_address, password: user.password }
      expect(response).to have_http_status(:success)
    end
  end
end
