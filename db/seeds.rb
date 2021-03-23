Doorkeeper::Application.destroy_all
Doorkeeper::Application.create(name: "starter_project_web", redirect_uri: "http://localhost:3000/")

# Add some data to start the app with

# Let us start by user with password that we will never know
first_user = User.create(email: Faker::Internet.email, password: Faker::Lorem.characters(number: 10))

# Now posting some questions
10.times do
  Question.create(
    title: Faker::Lorem.question,
    description: Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4),
    user_id: first_user.id,
    tagsstring: Faker::Creature::Cat.registry
  )
end

# I will leave answers for you, If you know how to speak spanish offcourse.