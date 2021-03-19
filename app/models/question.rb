class Question < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :user
  has_many :answers
  has_many :tags
end
