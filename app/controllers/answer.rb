# get form for user to post answer
get '/questions/:id/answers/new' do
  if logged_in?
    @question = Question.find_by_id(params[:id])
    erb :"static/answers/answer_form"
  else
    flash[:info] = "You need to log in to answer the question."
    redirect '/questions'
  end
end

# create answer
post '/questions/:id/answers' do
  params[:answer][:user_id] = current_user.id
  answer = Answer.new(params[:answer])
  if answer.save
    flash[:msg] = "Answer posted successfully"
    redirect '/users/'+ current_user.id.to_s + '/answers'
  else
    flash[:error] = answer.errors.full_messages.join('. ')
    redirect '/questions/'+ params[:answer][:question_id].to_s + '/answers'
    redirect '/questions'
  end
end

# show all answers user posted
get '/users/:id/answers' do
  @answers = Answer.where(user_id: params[:id]).order('created_at desc')
  erb :"static/answers/my_answers"
end

# delete particular answer
delete '/answers/:id' do
  answer = Answer.find(params[:id])
  answer.delete
  flash[:msg] = "Answer deleted"
  redirect '/users/'+ current_user.id.to_s + '/answers'
end

# get form for editing an answer
get '/answers/:id/edit' do
  @answer = Answer.find(params[:id])
  @question = Question.find(@answer.question_id)
  erb :'static/answers/edit'
end

# update edited answer
put '/answers/:id' do
  @answer = Answer.find(params[:id])
  if @answer.update(params[:answer])
    flash[:msg] = "Answer updated successfully"
  else
    flash[:error] = "Invalid input"
  end
  redirect '/users/' + current_user.id.to_s + '/answers'
end
