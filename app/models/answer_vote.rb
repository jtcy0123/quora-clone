class AnswerVote < ActiveRecord::Base
  # This is Sinatra! Remember to create a migration!
  belongs_to :answer
  belongs_to :user

  validates :user_id, presence: true
  validates :answer_id, presence: true
  validates_uniqueness_of :answer_id, scope: :user_id
end
