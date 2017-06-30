class Question < ActiveRecord::Base
  # This is Sinatra! Remember to create a migration!
  belongs_to :user
  has_many :answers

  validates :subject, presence: true, length: { in: 3..90 }
  validates :tag, presence: true
  # validates :description, presence: true

end
