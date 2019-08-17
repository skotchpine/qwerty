%w[
  rubygems
  sinatra
  sinatra/reloader
  sinatra/content_for
  haml
  sequel
  sinatra/sequel
  sequel_secure_password
  sqlite3
]
  .each(&method(:require))

#
# Sinatra Setup
#
set :public_folder, File.dirname(__FILE__)
set :database, 'sqlite://qwerty.db'
enable :sessions
set :session_store, Rack::Session::Pool
use Rack::Session::Pool, :expire_after => 2592000
use Rack::Protection::RemoteToken
use Rack::Protection::SessionHijacking

#
# USERS
#
if not database.table_exists?(:users)
  migration 'create users' do
    database.create_table :users do
      primary_key :id

      String :first_name
      String :last_name
      String :password_digest
      
      timestamp :created_at
      timestamp :updated_at
    end
  end
end

#
# LESSONS
#
if not database.table_exists?(:lessons)
  migration 'create lessons' do
    database.create_table :lessons do
      primary_key :id

      Integer :position
      String :title
    end
  end
end

#
# EXERCISES
#
if not database.table_exists?(:exercises)
  migration 'create exercises' do
    database.create_table :exercises do
      primary_key :id
      foreign_key :lesson_id, :lessons, null: false

      Integer :position
      String :exercise
    end
  end
end

#
# SUBMISSIONS
#
if not database.table_exists?(:submissions)
  migration 'create submissions' do
    database.create_table :submissions do
      primary_key :id
      foreign_key :user_id,     :users,     null: false
      foreign_key :exercise_id, :exercises, null: false

      Integer :right,    null: false
      Integer :wrong,    null: false
      Integer :accuracy, null: false
      Integer :wpm,      null: false
      Integer :passed,   null: false
      
      timestamp :created_at
    end
  end
end

#
# Models
#
class User < Sequel::Model
  one_to_many :submissions
  plugin :secure_password
end

class Lesson < Sequel::Model
  one_to_many :exercises
end

class Exercise < Sequel::Model
  many_to_one :lesson
  one_to_many :submissions
end

class Submission < Sequel::Model
  many_to_one :exercise
  many_to_one :user
end

if Lesson.all.none?
  {
    'Home Row' => %w[
      jjkjk jkjkk kjkkj jkjjj jkkkj jkjkj kjkkj kkjkj
      ddfdf dfdff fdffd dfddd dfffd dfdfd fdffd ffdfd
    ],
    'Index Fingers' => %w[],
    'Pinkies' => %w[],
    'Repetition 1' => %w[],
    'Repetition 2' => %w[],
    'Repetition 3' => %w[],
    'Repetition 4' => %w[],
    'Mostly Vowels' => %w[],
    'Full Alphabet' => %w[],
    'Common Chords' => %w[],
    'Top Row' => %w[],
    'Shift Keys' => %w[],
    'Top Row 2' => %w[],
    'Sentences' => %w[],
  }
    .each_with_index do |(title, exercises), i|
      lesson = Lesson.create(title: title, position: i)
      exercises.each_with_index do |exercise, j|
        lesson.add_exercise(exercise: exercise, position: j)
      end
    end
end

class Key
  attr_accessor :on, :off, :code, :finger

  def initialize(on, off, code, finger)
    @on, @off, @code, @finger = on, off, code, finger
  end
end

def key_rows
 [
    [
      %w[`         ~         192 0],
      %w[1         !         49  1],
      %w[2         @         50  1],
      %w[3         #         51  2],
      %w[4         $         52  3],
      %w[5         %         53  4],
      %w[6         ^         54  4],
      %w[7         &         55  5],
      %w[8         *         56  6],
      %w[9         (         57  7],
      %w[0         )         48  8],
      %w[-         _         189 8],
      %w[=         +         187 8],
      %w[backspace backspace 8   0],
    ],
    [
      %w[tab  tab 9   0],
      %w[q    Q   81  1],
      %w[w    W   87  2],
      %w[e    E   69  3],
      %w[r    R   82  4],
      %w[t    T   84  4],
      %w[y    Y   89  5],
      %w[u    U   85  5],
      %w[i    I   73  6],
      %w[o    O   79  7],
      %w[p    P   80  8],
      %w[\[   {   219 8],
      %w[\]   }   221 8],
      %w[\\   |   220 8],
    ],
    [
      %w[caps    caps    20  0],
      %w[a       A       65  1],
      %w[s       S       83  2],
      %w[d       D       68  3],
      %w[f       F       70  4],
      %w[g       G       71  4],
      %w[h       H       72  5],
      %w[j       J       74  5],
      %w[k       K       75  6],
      %w[l       L       76  7],
      %w[;       :       186 8],
      %w['       "       222 8],
      %w[enter   enter   13  0],
    ],
    [
      %w[shift_l   shift_l   16a    0],
      %w[z         Z         90     1],
      %w[x         X         88     2],
      %w[c         C         67     3],
      %w[v         V         86     4],
      %w[b         B         66     4],
      %w[n         N         78     5],
      %w[m         M         77     5],
      %w[,         <         188    6],
      %w[.         >         190    7],
      %w[/         ?         191    8],
      %w[shift_r   shift_r   16b    0],
    ],
    [
      %w[space space 32 0]
    ],
  ].map do |row|
    row.map { |key| Key.new(*key) }
  end
end

def lesson_keys
  'jjkjj jkjkk kjkkj kkjkk kkjjk jkjjk kjkjj'.split('')
  # 'One Lone Ranger shot arrows around the moon'.split('')
end

template :layout do
  File.read(File.join(__dir__, 'views', 'layout.haml'))
end

get '/' do
  if session[:user_id]
    redirect '/app/home', 301
  else
    redirect '/auth/sign_in', 301
  end
end

before '/auth/*' do
  request.path_info = "/app/home" if session[:user_id]
end

get '/auth/sign_up' do
  if session[:user_id]
    redirect "/app/home?error=You're already signed in", 301
  else
    haml :sign_up
  end
end

get '/auth/sign_in' do
  if session[:user_id]
    redirect "/app/home?error=You're already signed in", 301
  else
    haml :sign_in
  end
end

post '/auth/sign_up' do
  users = User.where(first_name: params[:first_name], last_name: params[:last_name])
  
  if users.any?
    redirect '/auth/sign_in?error=You already have an account. Sign in here.', 301
  else

    user = User.new \
      first_name: params[:first_name],
      last_name: params[:last_name],
      password: params[:password],
      password_confirmation: params[:password]

    if user.save
      redirect '/app/home', 301
    else
      haml :sign_up
    end
  end
end

post '/auth/sign_in' do
  user = User.where(first_name: params[:first_name], last_name: params[:last_name]).first

  if user
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:first_name] = user.first_name
      session[:last_name] = user.last_name

      redirect '/app/home', 301
    else
      redirect "/auth/sign_in?error=Access denied.", 403
    end
  else
    redirect "/auth/sign_in?error=That account doesn't exist.", 403
  end
end

before '/app/*' do
  request.path_info = "/sign_in?error=You have to sign in first." unless session[:user_id]
end

get '/app/sign_out' do
  session.clear
  haml :sign_in
end

get '/app/home' do
  lessons = Lesson.all
  haml :home, locals: { first_name: session[:first_name], lessons: lessons }
end

get '/app/lessons/:lesson_index/exercises/:exercise_index' do
  haml :lesson, locals: { key_rows: key_rows, lesson_keys: lesson_keys }
end

post '/app/lessons/:lesson_index/exercises/:exercise_index' do
  { right: params[:right], wrong: params[:wrong], accuracy: params[:accuracy], wpm: params[:wpm] }.to_json
end

get '/app/lessons/:lesson_index/exercises/:exercise_index/summary' do
  haml :summary, locals: { right: 20, wrong: 5, accuracy: '80%', wpm: 35}
end