#
# Sinatra Setup
#
set :public_folder, File.join(File.dirname(File.dirname(__dir__)), 'static')
set :database, 'sqlite://qwerty.db'
enable :sessions
set :session_store, Rack::Session::Pool
use Rack::Session::Pool, :expire_after => 2592000
use Rack::Protection::RemoteToken
use Rack::Protection::SessionHijacking