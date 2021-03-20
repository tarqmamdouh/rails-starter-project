class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :author, :created_at, :updated_at

  def author
    {
      author_id: object.user.id,
      author_email: object.user.email
    }
  end
end
