require 'rails_helper'

RSpec.describe Api::V1::CandidatesController, type: :controller do
  describe 'GET #index' do
    let!(:candidates) { create_list(:candidate, 3) }

    it 'returns list of all candidates' do
      get :index

      expect(JSON.parse(response.body).size).to eq 3
    end
  end

  describe 'GET #show' do
    let!(:candidate) { create(:candidate) }

    it 'returns data for candidate' do
      get :show, params: { id: candidate.id }
      result = JSON.parse(response.body)

      expect(result['email']).to eq candidate.email
      expect(result['time_slots']).to eq []
    end
  end

  describe 'POST #create' do
    let(:email) { 'frodo@middleearth.com' }

    it 'creates candidate' do
      post :create, params: { candidate: { email: email } }
      result = JSON.parse(response.body)

      expect(result['email']).to eq email
    end
  end

  describe 'PUT #update' do
    let!(:candidate_frodo) { create(:candidate, email: 'frodo@middleearth.com') }
    let!(:candidate_bilbo) { create(:candidate, email: 'bilbo@middleearth.com') }

    context 'on success' do
      let(:new_email) { 'gandalf@middleearth.com' }

      it 'updates candidate' do
        put :update, params: { id: candidate_frodo.id, candidate: { email: new_email } }
        result = JSON.parse(response.body)

        expect(result['email']).to eq new_email
      end
    end

    context 'on failure' do
      let(:already_taken_email) { 'bilbo@middleearth.com' }

      it 'returns validation error' do
        put :update, params: { id: candidate_frodo.id, candidate: { email: already_taken_email} }
        result = JSON.parse(response.body)

        expect(response.status).to eq 422
        expect(result['errors']).to include 'Email has already been taken'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:candidate) { create(:candidate) }

    it 'removes candidate' do
      delete :destroy, params: { id: candidate.id }

      expect(response.status).to eq 200
    end
  end
end
