class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.integer :question_id, index: true, foreign_key: true
      t.string :name
      t.string :hexcolor
      t.timestamps
    end
  end
end
