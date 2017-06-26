class CreateVotes < ActiveRecord::Migration[4.2]
  def change
    remove_column :questions, :votes
    remove_column :answers, :votes

    create_table :question_votes do |q|
      q.references :question
      q.references :user
      q.integer :vote, default: 0
      q.timestamps
    end

    create_table :answer_votes do |a|
      a.references :answer
      a.references :user
      a.integer :vote, default: 0
      a.timestamps
    end

    add_index :question_votes, [:user_id, :question_id], unique: true
    add_index :answer_votes, [:user_id, :answer_id], unique: true

  end
end
