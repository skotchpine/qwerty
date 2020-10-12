Rails.application.routes.draw do
  # TODO: Get rid of the info controller and it's routes
  root to: 'info#anyone'
  get :anyone, to: 'info#anyone'
  get :users, to: 'info#users'
end
