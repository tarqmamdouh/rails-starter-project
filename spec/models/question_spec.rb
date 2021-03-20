require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create :question }

  it 'order is by date descending' do
    user = FactoryBot.create(:user)
    create :question, title: 'first', description: 'first', user_id: user.id, created_at: 2.day.ago
    create :question, title: 'second', description: 'second', user_id: user.id, created_at: 1.days.ago

    expect(Question.first.title).to eq('second')
  end

  it 'url is built based on slug' do
    expect(question.to_param).to eq question.slug
  end

  it 'deserializes tags from a comma-separated string' do
    question = build :question, tags_string: 'abc, xyz'

    expect(question.tags.map(&:name)).to eq %w[abc xyz]
  end

  it 'serializes tags to a comma-separated string' do
    user = FactoryBot.create(:user)
    question = FactoryBot.create(:question)
    tag_abc = build :tag, name: 'abc'
    tag_xyz = build :tag, name: 'xyz'

    question = build :question, tags: [tag_abc, tag_xyz]

    expect(question.tags_string).to eq 'abc, xyz'
  end

  describe '(validations)' do
    subject { question }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_uniqueness_of(:slug).case_insensitive }

    %w[a aaa a-a aaa-aaa aaa-aaa-aaa].each do |slug|
      it { should allow_value(slug).for(:slug) }
    end
  end
end
