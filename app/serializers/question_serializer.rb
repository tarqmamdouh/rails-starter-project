class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :slug, :title, :description, :tags, :author

  def tags
    self.object.tags.map(&:name).join(', ')
  end

  def author
    {
      author_id: self.object.user.id, 
      author_email: self.object.user.email
    }
  end
end
