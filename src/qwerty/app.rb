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

  first_incomplete_lesson_found = false
  lessons_vm = Lesson.ordered.map.with_index do |lesson, i|
    lesson_complete, lesson_accurate, lesson_fast =
      lesson.complete(user_id), lesson.accurate(user_id), lesson.fast(user_id)

    first_incomplete_lesson =
      if lesson_complete || first_incomplete_lesson_found
        false
      else
        first_incomplete_lesson_found = true
        true
      end

    first_incomplete_exercise_found = false
    exercises_vm = lesson.exercises_dataset.ordered.map.with_index do |exercise, j|
      exercise_complete, exercise_accurate, exercise_fast =
        exercise.complete(user_id), exercise.accurate(user_id), exercise.fast(user_id)

      
      first_incomplete_exercise =
        if exercise_complete || first_incomplete_exercise_found
          false
        else
          first_incomplete_exercise_found = true
          true
        end

      {
        id: exercise.id,
        title: exercise.title,
        position: exercise.position,
        
        complete: exercise_complete,
        accurate: exercise_accurate,
        fast: exercise_fast,

        next: first_incomplete_exercise,
        btn_class: (!first_incomplete_exercise && first_incomplete_exercise_found)  ? 'incomplete' : 'btn-light',
        disabled: !first_incomplete_exercise && first_incomplete_exercise_found,
      }
    end

    {
      id: lesson.id,
      title: lesson.title,
      position: lesson.position,

      tag: "lesson-#{lesson.id}",
      exercises_tag: "lesson-#{lesson.id}-exercises",

      complete: lesson_complete,
      accurate: lesson_accurate,
      fast: lesson_fast,

      next: first_incomplete_lesson,
      bg_class: (!first_incomplete_lesson && first_incomplete_lesson_found) ? 'incomplete' : 'bg-light',
      disabled: !first_incomplete_lesson && first_incomplete_lesson_found,

      exercises: exercises_vm,
    }
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

  fastest_query = <<~SQL
    select u.username as username,
           max(s.wpm) as wpm
    from users u
    join submissions s on s.user_id = u.id
    group by u.id
    order by wpm desc
    limit 5
  SQL
  fastest = database.execute(fastest_query).to_a

  farthest_query = <<~SQL
    select u.username as username,
           max(l.position) as lesson,
           max(e.position) as exercise
    from users u
    join submissions s on s.user_id = u.id
    join exercises e on s.exercise_id = e.id
    join lessons l on e.lesson_id = l.id
    group by u.id
    order by lesson desc
    limit 5
  SQL
  farthest = database.execute(farthest_query).to_a

  haml :home, locals: {
    user_id: user_id,

    avg_wpm: stats[:avg_wpm].to_i.round(1),
    avg_typos: stats[:avg_typos].to_i.round(1),
    avg_accuracy: stats[:avg_accuracy].to_i.round(1),
    total_typos: stats[:total_typos].to_i.round(1),
    total_subimssions: stats[:total_submissions].to_i,

    fastest: fastest,
    farthest: farthest,
    tip: TIPS.sample,

    lessons: lessons_vm,
  }
end

get '/app/lessons/:lesson_id/exercises/:exercise_id' do
  lesson = Lesson.where(id: params[:lesson_id].to_i).first
  exercise = Exercise.where(id: params[:exercise_id].to_i).first

  haml :exercise, locals: {
    key_rows: Keyboard.rows,
    exercise: exercise,
    lesson: lesson,
  }
end

post '/app/lessons/:lesson_id/exercises/:exercise_id' do
  submission =
    Submission.from_results \
      session[:user_id].to_i,
      params[:exercise_id].to_i,
      params[:right].to_i,
      params[:wrong].to_i,
      params[:accuracy],
      params[:wpm].to_i

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

    max_typos: exercise.max_typos,
    min_wpm: exercise.min_wpm,
    fast_wpm: exercise.fast_wpm,

    exercise: exercise,
    lesson: lesson,

    next_path: next_path,
  }
end  