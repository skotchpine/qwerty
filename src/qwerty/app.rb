before '/app/*' do
  redirect "/auth/sign_in", 301 unless session[:user_id]
end

get '/app/sign_out' do
  puts session
  session.clear
  puts session
  redirect :sign_in, 301
end

get '/app/home' do
  # redirect 'http://localhost:4567/app/lessons/1/exercises/1', 301
  lessons = Lesson.all
  haml :home, locals: { first_name: session[:first_name], lessons: lessons }
end

get '/app/lessons/:lesson_id/exercises/:exercise_id' do
  lesson = Lesson.where(id: params[:lesson_id].to_i).first
  exercise = Exercise.where(id: params[:exercise_id].to_i).first
  haml :exercise, locals: { key_rows: Keyboard.rows, exercise: exercise, lesson: lesson }
end

post '/app/lessons/:lesson_id/exercises/:exercise_id' do
  submission =
    Submission.create \
      user_id: session[:user_id].to_i,
      exercise_id: params[:exercise_id].to_i,
      right: params[:right],
      wrong: params[:wrong],
      accuracy: params[:accuracy],
      wpm: params[:wpm],
      created_at: DateTime.now
  { id: submission.id }.to_json
end

get '/app/submissions/:submission_id' do
  submission = Submission.where(id: params[:submission_id].to_i).first
  exercise = submission.exercise
  lesson = exercise.lesson

  next_path =
    if lesson.exercises.last == exercise
      next_lesson = Lesson.where(position: lesson.position + 1).first

      if next_lesson
        "/app/lessons/#{next_lesson.id}/exercises/1"
      else
        "/app/home"
      end
    else
      next_exercise = Exercise.where(lesson_id: lesson.id, position: exercise.position + 1).first

      "/app/lessons/#{lesson.id}/exercises/#{next_exercise.id}"
    end

  haml :summary, locals: {
    right: submission.right,
    wrong: submission.wrong,
    accuracy: submission.accuracy,
    wpm: submission.wpm,
    exercise: exercise,
    lesson: lesson,
    next_path: next_path
  }
end  