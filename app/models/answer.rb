class Answer < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  validates :body, presence: true
  validates :question_id, presence: true
end
