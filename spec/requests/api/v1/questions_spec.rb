require 'rails_helper'

RSpec.describe 'Api::V1::QuestionsController', type: :request do
  let(:question) { create :question }

  describe 'when not signed in' do
    describe 'Can see question' do
      before { get "/api/v1/questions/#{question.slug}" }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'Can list questions' do
      before { get '/api/v1/questions' }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'Cannot edit questions' do
      before { put "/api/v1/questions/#{question.slug}" }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    describe 'Cannot ask a question' do
      before { post '/api/v1/ask' }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    describe 'Cannot delete questions' do
      before { delete "/api/v1/questions/#{question.slug}" }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'when signed in' do
    let!(:application) { FactoryBot.create(:application) }
    let!(:user)        { FactoryBot.create(:user) }
    let!(:token)       { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

    describe 'creates question' do
      context '(valid data)' do
        it 'creates new question' do
          valid_data = attributes_for :question

          expect do
            post '/api/v1/ask', params: { data: { attributes: valid_data } }, headers: { 'Authorization': 'Bearer ' + token.token }
          end.to change(Question, :count).by(1)
        end
      end

      context '(invalid data)' do
        it 'does not create new question' do
          invalid_data = attributes_for :question, title: ''

          expect do
            post '/api/v1/ask', params: { data: { attributes: invalid_data } }, headers: { 'Authorization': 'Bearer ' + token.token }
          end.not_to change(Question, :count)
        end
      end
    end

    describe 'updates question with' do
      context '(valid data)' do
        let(:valid_question) do
          attributes_for :question, title: 'new'
        end

        it 'updates the question' do
          put "/api/v1/questions/#{question.slug}", params: { data: { attributes: valid_question } }, headers: { 'Authorization': 'Bearer ' + token.token }
          expect(question.reload.title).to eq('new')
        end
      end

      context '(invalid data)' do
        it 'does not update the question' do
          invalid_question = attributes_for :question, title: ''
          put "/api/v1/questions/#{question.slug}", params: { data: { attributes: invalid_question } }, headers: { 'Authorization': 'Bearer ' + token.token }
          expect(question.reload.title).not_to eq('new')
        end
      end
    end

    describe 'deletes question' do
      it 'deletes question' do
        delete "/api/v1/questions/#{question.slug}", headers: { 'Authorization': 'Bearer ' + token.token }
        expect(Question.exists?(question.id)).to be_falsy
      end
    end
  end
end
