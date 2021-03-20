class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  has_many :taggings, dependent: :destroy
  has_many :questions, through: :taggings
end
