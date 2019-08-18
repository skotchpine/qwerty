before '/app/*' do
  redirect "/auth/sign_in", 301 unless session[:user_id]
end

get '/app/sign_out' do
  puts session
  session.clear
  puts session
  redirect '/auth/sign_in', 301
end

get '/app/home' do
  user_id = session[:user_id]

  last_complete_lesson_index = -1
  lessons_vm = Lesson.all.map.with_index do |lesson, i|
    lesson_complete, lesson_accurate, lesson_fast =
      lesson.complete(user_id), lesson.accurate(user_id), lesson.fast(user_id)

    last_complete_lesson_index = i if lesson_complete

    last_complete_exercise_index = -1
    exercises_vm = lesson.exercises.map.with_index do |exercise, j|
      exercise_complete, exercise_accurate, exercise_fast =
        exercise.complete(user_id), exercise.accurate(user_id), exercise.fast(user_id)

      last_complete_exercise_index = j if exercise_complete

      {
        id: exercise.id,
        
        complete: exercise_complete,
        accurate: exercise_accurate,
        fast: exercise_fast,

        next: false,
        btn_class: exercise_complete ? 'btn-light' : 'btn-disabled',
        disabled: !exercise_complete,
      }
    end
    if last_complete_exercise_index < exercises_vm.size - 1
      exercises_vm[last_complete_exercise_index + 1][:next] = true
      exercises_vm[last_complete_exercise_index + 1][:btn_class] = 'btn-light'
      exercises_vm[last_complete_exercise_index + 1][:disabled] = false
    end

    {
      id: lesson.id,
      title: lesson.title,

      tag: "lesson-#{lesson.id}",
      exercises_tag: "lesson-#{lesson.id}-exercises",

      complete: lesson_complete,
      accurate: lesson_accurate,
      fast: lesson_fast,

      next: false,
      bg_class: lesson_complete ? 'bg-light' : 'incomplete',
      disabled: !lesson_complete,

      exercises: exercises_vm,
    }
  end
  if last_complete_lesson_index < lessons_vm.size - 1
    lessons_vm[last_complete_lesson_index + 1][:next] = true
    lessons_vm[last_complete_lesson_index + 1][:bg_class] = 'bg-light'
    lessons_vm[last_complete_lesson_index + 1][:disabled] = false
  end

  stats_query = <<~SQL
    select AVG(wpm) as avg_wpm,
           SUM(wrong) as total_typos,
           COUNT(id) as total_submissions,
           AVG(wrong) as avg_typos,
           AVG(accuracy) as avg_accuracy
    from submissions
    where user_id = #{user_id};
  SQL
  stats = database.fetch(stats_query).first
  puts stats

  haml :home, locals: {
    user_id: user_id,

    avg_wpm: stats[:avg_wpm].round(1),
    avg_typos: stats[:avg_typos].round(1),
    avg_accuracy: stats[:avg_accuracy].round(1),
    total_typos: stats[:total_typos].round(1),
    total_subimssions: stats[:total_submissions],

    lessons: lessons_vm,
  }
end

get '/app/lessons/:lesson_id/exercises/:exercise_id' do
  lesson = Lesson.where(id: params[:lesson_id].to_i).first
  exercise = Exercise.where(id: params[:exercise_id].to_i).first
  haml :exercise, locals: { key_rows: Keyboard.rows, exercise: exercise, lesson: lesson }
end

post '/app/lessons/:lesson_id/exercises/:exercise_id' do
  complete = params[:wrong].to_i < 6
  accurate = complete && params[:accuracy] == '100%'
  fast = accurate && params[:wpm].to_i > 30

  submission =
    Submission.create \
      user_id: session[:user_id].to_i,
      exercise_id: params[:exercise_id].to_i,

      right: params[:right],
      wrong: params[:wrong],
      accuracy: params[:accuracy],
      wpm: params[:wpm],

      complete: complete,
      accurate: accurate,
      fast: fast,

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

      redirect '/app/home', 301 unless next_lesson

      next_exercise = Exercise.where(lesson_id: next_lesson.id, position: 0).first

      if next_lesson
        "/app/lessons/#{next_lesson.id}/exercises/#{next_exercise.id}"
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

    complete: submission.complete,
    accurate: submission.accurate,
    fast: submission.fast,

    exercise: exercise,
    lesson: lesson,

    next_path: next_path,
  }
end  