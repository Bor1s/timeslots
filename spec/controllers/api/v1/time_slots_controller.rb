require 'rails_helper'

RSpec.describe Api::V1::TimeSlotsController, type: :controller do
  describe 'GET #index' do
    context 'when no user ids provided' do
      it 'returns error' do
        get :index
        result = JSON.parse(response.body)

        expect(response.status).to eq 500
        expect(result['error']).to eq 'param is missing or the value is empty: user_ids'
      end
    end

    context 'when there is one user with a few slots' do
      let!(:candidate) { create(:candidate) }
      let(:slot1) { Time.current..Time.current + 1.hour }
      let(:slot2) { Time.current + 2.hours..Time.current + 4.hours }
      let!(:time_slot1) { create(:time_slot, user_id: candidate.id, slot: slot1) }
      let!(:time_slot2) { create(:time_slot, user_id: candidate.id, slot: slot2) }

      context 'and single user id provided in params' do
        it 'returns error' do
          get :index, params: { user_ids: [candidate.id] }
          result = JSON.parse(response.body)

          expect(result['error']).to eq "No common time slots found for users: #{candidate.id}"
        end
      end
    end

    context 'when there is one user with no slots' do
      let!(:candidate) { create(:candidate) }

      context 'and single user id provided in params' do
        it 'returns error' do
          get :index, params: { user_ids: [candidate.id] }
          result = JSON.parse(response.body)

          expect(result['error']).to eq "No common time slots found for users: #{candidate.id}"
        end
      end
    end

    context 'when there are more than one user' do
      context 'and then have no common slots' do
        let!(:candidate1) { create(:candidate) }
        let(:slot1) { Time.current..Time.current + 1.hour }
        let(:slot2) { Time.current + 2.hours..Time.current + 4.hours }
        let!(:time_slot1) { create(:time_slot, user_id: candidate1.id, slot: slot1) }
        let!(:time_slot2) { create(:time_slot, user_id: candidate1.id, slot: slot2) }

        let!(:candidate2) { create(:candidate) }
        let(:slot3) { Time.current.tomorrow..Time.current.tomorrow + 1.hour }
        let(:slot4) { Time.current.tomorrow + 2.hours..Time.current.tomorrow + 4.hours }
        let!(:time_slot3) { create(:time_slot, user_id: candidate2.id, slot: slot3) }
        let!(:time_slot4) { create(:time_slot, user_id: candidate2.id, slot: slot4) }

        it 'returns error message' do
          get :index, params: { user_ids: [candidate1.id, candidate2.id] }
          result = JSON.parse(response.body)

          expect(result['error']).to eq "No common time slots found for users: #{candidate1.id},#{candidate2.id}"
        end
      end

      context 'and then have 1 slot in common' do
        let!(:candidate1) { create(:candidate) }
        let(:slot1) { Time.current..Time.current + 1.hour }
        let(:slot2) { Time.current + 2.hours..Time.current + 4.hours }
        let!(:time_slot1) { create(:time_slot, user_id: candidate1.id, slot: slot1) }
        let!(:time_slot2) { create(:time_slot, user_id: candidate1.id, slot: slot2) }

        let!(:candidate2) { create(:candidate) }
        let(:slot3) { Time.current..Time.current + 1.hour }
        let(:slot4) { Time.current.tomorrow + 2.hours..Time.current.tomorrow + 4.hours }
        let!(:time_slot3) { create(:time_slot, user_id: candidate2.id, slot: slot3) }
        let!(:time_slot4) { create(:time_slot, user_id: candidate2.id, slot: slot4) }

        it 'returns only overlapping time between common slots' do
          get :index, params: { user_ids: [candidate1.id, candidate2.id] }
          result = JSON.parse(response.body)

          expect(result).to eq [{'start' => slot1.begin.to_s(:db), 'end' => slot3.end.to_s(:db)}]
        end
      end

      context 'and then have more than 1 slot in common' do
        let!(:candidate1) { create(:candidate) }
        let(:slot1) { Time.current..Time.current + 1.hour }
        let(:slot2) { Time.current + 2.hours..Time.current + 6.hours }
        let!(:time_slot1) { create(:time_slot, user_id: candidate1.id, slot: slot1) }
        let!(:time_slot2) { create(:time_slot, user_id: candidate1.id, slot: slot2) }

        let!(:candidate2) { create(:candidate) }
        let(:slot3) { Time.current..Time.current + 1.hour }
        let(:slot4) { Time.current + 3.hours..Time.current + 5.hours }
        let!(:time_slot3) { create(:time_slot, user_id: candidate2.id, slot: slot3) }
        let!(:time_slot4) { create(:time_slot, user_id: candidate2.id, slot: slot4) }

        it 'returns multiple overlapping times between common slots' do
          get :index, params: { user_ids: [candidate1.id, candidate2.id] }
          result = JSON.parse(response.body)

          expect(result).to eq [
            {'start' => slot1.begin.to_s(:db), 'end' => slot3.end.to_s(:db)},
            {'start' => slot4.begin.to_s(:db), 'end' => slot4.end.to_s(:db)}
          ]
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when time slots are valid' do
      let!(:candidate) { create(:candidate) }
      let(:slots_params) { { user_id: candidate.id, time_slots: [
        {start: Time.current + 1.hour, end: Time.current + 2.hours},
        {start: Time.current + 4.hours, end: Time.current + 5.hours}
      ]} }

      it 'creates time slots from user' do
        post :create, params: slots_params
        result = JSON.parse(response.body)

        expect(result['email']).to eq candidate.email
        expect(result['time_slots'].size).to eq 2
      end
    end

    context 'when time slots ranges already exists' do
      let!(:candidate) { create(:candidate) }
      let(:slot) { Time.current..Time.current + 1.hour }
      let!(:time_slot) { create(:time_slot, user_id: candidate.id, slot: slot) }
      let(:slots_params) { { user_id: candidate.id, time_slots: [
        {start: Time.current - 1.hour, end: Time.current + 2.hours}
      ]} }

      it 'returns error' do
        post :create, params: slots_params
        result = JSON.parse(response.body)

        expect(response.status).to eq 500
        expect(result['error']).to include 'PG::ExclusionViolation'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:slot) { Time.current..Time.current + 1.day }
    let!(:time_slot) { create(:time_slot, :for_candidate, slot: slot) }

    it 'removes time slot' do
      delete :destroy, params: { id: time_slot.id }

      expect(response.status).to eq 200
    end
  end
end
