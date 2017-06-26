# add vote to answer
post '/answers/:id/add' do
  if logged_in?
    @new_vote = AnswerVote.new(user_id: current_user.id, answer_id: params[:id])
    if @new_vote.save
      @new_vote.update_attributes(vote: 1)
    else
      @v = AnswerVote.find_by(user_id: current_user.id, answer_id: params[:id])
      @v.vote == 0 ? @v.vote += 1 : @v.vote -=1
      @v.save
    end
    redirect back
  else
    flash[:info] = "You need to log in to vote for the answer."
    redirect back
  end
end
