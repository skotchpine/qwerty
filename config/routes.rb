Rails.application.routes.draw do
  get 'home/home'
  devise_for :users

  # TODO: Get rid of the info controller and it's routes
  #root to: 'info#anyone'
  devise_scope :user do
    authenticated :user do
      root 'home#home',as: :home_page
      
    end
    unauthenticated do
      root 'devise/sessions#new',as: :home
    end
  end
  

 

  #get :anyone, to: 'info#anyone'
  #get :users, to: 'info#users'
end
