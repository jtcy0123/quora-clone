# add vote to question
post '/questions/:id/add' do
  if logged_in?
    @v = QuestionVote.new(user_id: current_user.id, question_id: params[:id])
    if @v.save
      @v.update_attributes(vote: 1)
    else
      @v = QuestionVote.find_by(user_id: current_user.id, question_id: params[:id])
      @v.vote == 0 ? @v.vote += 1 : @v.vote -=1
      @v.save
    end
    a = {id: params[:id], vote: @v.vote}
    return a.to_json
  else
    status 400
    return "You need to log in to vote for the question."
  end
end
