module QuestionFinder
  module_function

  def run(slug)
    Question.find_by(slug: slug)
  end
end
