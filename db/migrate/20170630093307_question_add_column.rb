class QuestionAddColumn < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :tag, :string
  end
end
