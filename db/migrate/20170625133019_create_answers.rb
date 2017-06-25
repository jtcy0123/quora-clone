class CreateAnswers < ActiveRecord::Migration[4.2]
  def change
    create_table :answers do |t|
      t.references :user
      t.references :question
      t.string :content
      t.integer :votes, default: 0
      t.timestamps
    end
  end
end
