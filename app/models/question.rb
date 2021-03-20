class Question < ApplicationRecord
  default_scope { order(created_at: :desc) }
  validates :title, presence: true
  validates :description, presence: true
  validates :slug, uniqueness: { case_sensitive: false }
  validates_associated :tags
  before_validation :set_slug, only: %i[create update]

  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :tags, through: :taggings

  def to_param
    slug.to_s
  end

  def tags_string=(string)
    self.tags = string.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  private

  def set_slug
    self.slug = title.to_s.parameterize
  end
end
