class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :slug, :title, :description, :tags, :author, :created_at

  def tags
    object.tags.map(&:name).join(', ')
  end

  def author
    {
      author_id: object.user.id,
      author_email: object.user.email
    }
  end
end
