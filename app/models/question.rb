class Question < ApplicationRecord
  default_scope { order(created_at: :desc) }
  validates :title, presence: true
  validates :description, presence: true
  validates :slug, presence: true, slug: true, uniqueness: {case_sensitive: false}

  belongs_to :user
  has_many :answers, dependent :destroy
  has_many :tags

  def tags_string=(string)
    self.tags = string.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def tags_string
    tags.map(&:name).join(', ')
  end
end
