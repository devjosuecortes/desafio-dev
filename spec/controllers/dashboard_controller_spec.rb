require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { User.create(name: "Ciclano", email: "ciclano@example.com", password: "password123", password_confirmation: "password123") }

  describe "GET #show" do
    context "with an authenticated user" do
      before do
        sign_in user
        get :show
      end

      it "returns HTTP 200 status" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    context "with an unauthenticated user" do
      before { get :show }

      it "redirects to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end

      it "shows an authentication error message" do
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end
  end
end
