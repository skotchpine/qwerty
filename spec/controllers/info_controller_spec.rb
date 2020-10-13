require 'rails_helper'

RSpec.describe InfoController, type: :controller do
  describe 'GET /users' do
    context 'when not logged in' do
      it 'should redirect to login' do
        get :users
        expect(response).to have_http_status(302)
      end
    end

    context 'when logged in' do
      login_user

      it 'should return 200' do
        get :users
        expect(response).to have_http_status(200)
      end
    end
  end
end