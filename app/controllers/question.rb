enable :sessions
set :session_secret, "My session secret"

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
  @questions = Question.where(user_id: params[:id]).order('created_at desc')
  erb :"static/questions/user_questions"
end

# show all questions
get '/questions' do
  # eg @votes = {50=>1, 53=>2}
  @votes = QuestionVote.group(:question_id).where(vote: 1).count
  if logged_in?
    # list of questions current user liked
    @questions = Question.order('created_at desc')
    @list = QuestionVote.where(user_id: current_user.id, vote: 1)
  else
    @questions = Question.order('created_at desc').first(5)
  end
  erb :"static/questions/all_questions"
end

# show particular question with all the respective answers
get '/questions/:id/answers' do
  @q = Question.find(params[:id])
  @answers = Answer.where(question_id: params[:id])
  # eg @votes = {50=>1, 53=>2}
  @votes = AnswerVote.group(:answer_id).where(vote: 1).count
  if logged_in?
    # list of questions current user liked
    @list = AnswerVote.where(user_id: current_user.id, vote: 1)
  end
  erb :"static/questions/answers_for_q"
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
  @question = Question.find(params[:id])
  erb :'static/questions/edit'
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
