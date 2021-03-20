module QuestionFinder
  extend self

  def run(slug)
    Question.find_by(slug: slug)
  end
end