# create the question user asks
post '/questions' do
  params[:question][:user_id] = current_user.id
  question = Question.new(params[:question])
  if question.save
    return question.to_json
  else
    status 400
    return question.errors.full_messages.join('. ')
  end
end

# show particular user's questions
get '/users/:id/questions' do
  if logged_in? && current_user.id == params[:id].to_i
    @questions = Question.where(user_id: params[:id]).order('created_at desc')
    erb :"static/questions/user_questions"
  elsif logged_in?
    redirect '/users/' + current_user.id.to_s + '/questions'
  else
    flash[:info] = "Please signup or login"
    redirect '/'
  end
end

# show all questions
get '/questions' do
  # eg @votes = {50=>1, 53=>2}
  @upvotes = QuestionVote.group(:question_id).where(vote: 1).count
  @downvotes = QuestionVote.group(:question_id).where(vote: -1).count
  if logged_in?
    # list of questions current user liked
    @questions = Question.order('created_at desc').paginate(:page => params[:page], :per_page => 5)
    @uplist = QuestionVote.where(user_id: current_user.id, vote: 1)
    @downlist = QuestionVote.where(user_id: current_user.id, vote: -1)
  else
    @questions = Question.order('created_at desc').first(5)
  end
  erb :"static/questions/all_questions"
end

# delete particular question
delete '/questions/:id' do
  questions = Question.find(params[:id])
  questions.delete
  flash[:msg] = "Question deleted"
  redirect '/users/'+ current_user.id.to_s + '/questions'
end

# get form for editing a question
get '/questions/:id/edit' do
  if logged_in?
    @question = Question.find(params[:id])
    if current_user.id == @question.user_id
      erb :'static/questions/edit'
    else
      flash[:info] = "That question don't belong to you."
      redirect '/users/' + current_user.id.to_s + '/questions'
    end
  else
    flash[:info] = "Please login to edit questions."
    redirect'/'
  end
end

# update the edited question
put '/questions/:id' do
  @question = Question.find(params[:id])
  if @question.update(params[:question])
    flash[:msg] = "Question updated successfully"
    redirect '/users/' + current_user.id.to_s + '/questions'
  else
    flash[:error] = @question.errors.full_messages.join('. ')
    erb :'static/questions/edit'
  end
end
