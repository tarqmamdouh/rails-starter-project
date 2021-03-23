class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :author, :created_at, :updated_at
 
  def author
    {
      authorid: object.user.id,
      authoremail: object.user.email
    }
  end
end
