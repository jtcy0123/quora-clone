class QuestionVote < ActiveRecord::Base
  # This is Sinatra! Remember to create a migration!
  belongs_to :question
  belongs_to :user

  validates :user_id, presence: true
  validates :question_id, presence: true
  validates_uniqueness_of :question_id, scope: :user_id
end
