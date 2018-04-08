require 'rails_helper'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  describe 'GET #index' do
    let!(:employees) { create_list(:employee, 3) }

    it 'returns list of all employees' do
      get :index

      expect(JSON.parse(response.body).size).to eq 3
    end
  end

  describe 'GET #show' do
    let!(:employee) { create(:employee) }

    it 'returns data for employee' do
      get :show, params: { id: employee.id }
      result = JSON.parse(response.body)

      expect(result['email']).to eq employee.email
      expect(result['time_slots']).to eq []
    end
  end

  describe 'POST #create' do
    let(:email) { 'frodo@middleearth.com' }

    it 'creates employee' do
      post :create, params: { employee: { email: email } }
      result = JSON.parse(response.body)

      expect(result['email']).to eq email
    end
  end

  describe 'PUT #update' do
    let!(:employee_frodo) { create(:employee, email: 'frodo@middleearth.com') }
    let!(:employee_bilbo) { create(:employee, email: 'bilbo@middleearth.com') }

    context 'on success' do
      let(:new_email) { 'gandalf@middleearth.com' }

      it 'updates employee' do
        put :update, params: { id: employee_frodo.id, employee: { email: new_email } }
        result = JSON.parse(response.body)

        expect(result['email']).to eq new_email
      end
    end

    context 'on failure' do
      let(:already_taken_email) { 'bilbo@middleearth.com' }

      it 'returns validation error' do
        put :update, params: { id: employee_frodo.id, employee: { email: already_taken_email} }
        result = JSON.parse(response.body)

        expect(response.status).to eq 422
        expect(result['errors']).to include 'Email has already been taken'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:employee) { create(:employee) }

    it 'removes employee' do
      delete :destroy, params: { id: employee.id }

      expect(response.status).to eq 200
    end
  end
end
