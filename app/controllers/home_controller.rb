class HomeController < ApplicationController
  def self.home
    user_id = session[:user_id]

    first_incomplete_lesson_found = false
    lessons_vm = Lesson.order(:position).map.with_index do |lesson, user_id|
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
      exercises_vm = lesson.exercises.ordered.map.with_index do |exercise, j|
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
    end
  end
end
