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

%w[
  setup
  migrations
  models
  seeds
  keyboard
  base
  auth
  app
]
  .each do |file|
    load File.join(__dir__, 'src', 'qwerty', "#{file}.rb")
  end