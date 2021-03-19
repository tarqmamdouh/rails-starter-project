class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :user_id, index: true, foreign_key: true
      t.string :title
      t.text :description
      t.string :slug
      t.timestamps
    end
  end
end
