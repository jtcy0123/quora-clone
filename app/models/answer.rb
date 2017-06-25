class Answer < ActiveRecord::Base
  # This is Sinatra! Remember to create a migration!
  belongs_to :user
  belongs_to :question

  validates :content, presence: true
end
