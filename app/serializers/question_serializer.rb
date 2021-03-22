class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :slug, :title, :description, :tags, :author, :tagsstring, :created_at, :answers

  def tags
    object.tags.map(&:name).join(', ')
  end

  def author
    {
      author_id: object.user.id,
      author_email: object.user.email
    }
  end

  has_many :answers

  # def answers
  #   object.answers.collect do |answer|
  #     {
  #         id: answer.id,
  #         body: answer.body,
  #     }
  #   end
  # end
end
