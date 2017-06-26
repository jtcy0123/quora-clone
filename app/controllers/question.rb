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
  erb :"static/questions"
end

# show all questions
get '/questions' do
  @questions = Question.order('created_at desc')
  erb :"static/all_questions"
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
