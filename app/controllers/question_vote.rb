# add upvote to question
post '/questions/:id/upvote' do
  if logged_in?
    @v = QuestionVote.new(user_id: current_user.id, question_id: params[:id])
    if @v.save
      @v.update_attributes(vote: 1)
    else
      @v = QuestionVote.find_by(user_id: current_user.id, question_id: params[:id])
      if @v.vote == 0
        @v.vote += 1
      elsif @v.vote == -1
        @v.vote +=2
      else
        @v.vote -= 1
      end
      @v.save
    end
    a = {id: params[:id], vote: @v.vote}
    return a.to_json
  else
    status 400
    return "You need to log in to vote for the question."
  end
end

# add downvote to question
post '/questions/:id/downvote' do
  if logged_in?
    @v = QuestionVote.new(user_id: current_user.id, question_id: params[:id])
    if @v.save
      @v.update_attributes(vote: 1)
    else
      @v = QuestionVote.find_by(user_id: current_user.id, question_id: params[:id])
      if @v.vote == 0
        @v.vote -= 1
      elsif @v.vote == -1
        @v.vote +=1
      else
        @v.vote -= 2
      end
      @v.save
    end
    a = {id: params[:id], vote: @v.vote}
    return a.to_json
  else
    status 400
    return "You need to log in to vote for the question."
  end
end
