class Question < ApplicationRecord
  default_scope { order(created_at: :desc) }
  validates :title, presence: true
  validates :description, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
  validates_associated :tags
  before_validation :set_slug, only: %i[create update]
  validates_presence_of :tags

  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :tags, through: :taggings

  ## Performs a join query to get questions tagged with specified tags
  #
  # @param tags [Array] an Array of strings, each string specify the tag that one or many
  # questions are tagged with (1 string required at least)
  # @return distinct [Array<Question>] of the questions whose tagged with one or more of search tags
  def self.all_tagged_with(tags)
    Question.joins(:tags).where('tags.name IN (?)', tags).uniq
  end

  def to_param
    slug.to_s
  end

  def tagsstring=(string)
    self.tags = string.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create
    end
  end

  def tagsstring
    tags.map(&:name).join(', ')
  end

  private

  def set_slug
    self.slug = title.to_s.parameterize
  end
end
