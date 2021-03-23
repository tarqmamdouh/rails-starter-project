class RemoveQuestionIdFromTag < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :question_id
  end
end
