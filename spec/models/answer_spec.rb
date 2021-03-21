require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create :question }
  let(:user) {create :user}
  let(:answer) {create :answer}

  it 'order is by date descending' do
    create :question, title: 'first', description: 'first', tags_string: 'abc', user_id: user.id, created_at: 2.day.ago
    create :question, title: 'second', description: 'second', tags_string: 'efg', user_id: user.id, created_at: 1.days.ago

    expect(Question.first.title).to eq('second')
  end
end
