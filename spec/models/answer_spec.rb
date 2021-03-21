require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create :question }
  let(:user) {create :user}
  let(:answer) {create :answer}

  it 'order is by date descending' do
    create :answer, body: 'I answered 2 days ago', user_id: user.id, question_id: question.id, created_at: 2.day.ago
    create :answer, body: 'I answered 1 day ago', user_id: user.id, question_id: question.id, created_at: 1.day.ago

    expect(Answer.first.body).to eq('I answered 1 day ago')
  end

  describe '(validations)' do
    subject { answer }

    it { should validate_presence_of(:body) }
  end
end
