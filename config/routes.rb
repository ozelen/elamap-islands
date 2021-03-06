ElamapIslands::Application.routes.draw do
  resources :scores


  resources :teachers


  resources :roles


  resources :user_sessions
  match 'login'  => "user_sessions#new",      as: :login
  match 'logout' => "user_sessions#destroy",  as: :logout

  resources :users
  resource :user, :as => 'account'  # a convenience route
  match 'signup' => 'users#new', :as => :signup
  match 'signup' => 'users#new', :as => :signup


  resources :hypsometries
  get 'tilemap' => 'map#tiles'
  get 'tilemockup' => 'map#mockup'
  get 'hypsometric-mockup' => 'map#hypsometric_mockup'

  root :to => 'map#index'

  resources :students do
    resources :scores
    #resources :sessions
  end

  get '/students/:student_id/sessions' => 'student#sessions'
  get '/students/:student_id/sessions/:session_id' => 'students#stud_session', as: :student_session
  get '/students/:student_id/units/:unit_id' => 'students#stud_unit', as: :student_unit
  get '/students/:student_id/texts/:text_id' => 'students#stud_text', as: :student_text


  resources :sessions do
    resources :units
    match 'structure'
    match 'upload'
    match "map"
  end


  resources :units do
    collection do
      get "structure"
    end
    resources :texts
  end


  resources :texts


  resources :islands
  resources :map


  #root :to => 'welcome#index'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
