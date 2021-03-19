class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.integer :user_id, index: true, foreign_key: true
      t.text :body
      t.timestamps
    end
  end
end
