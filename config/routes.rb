ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  map.login  '/login',  :controller => 'users', :action => 'login'
  map.logout  '/logout',  :controller => 'users', :action => 'logout'
  map.user_profile  '/user_profile',  :controller => 'users', :action => 'user_profile'
  map.settings  '/settings',  :controller => 'admin', :action => 'settings'
  map.add_user  '/add_user',  :controller => 'admin', :action => 'add_user'
  map.add_tournament  '/add_tournament',  :controller => 'admin', :action => 'add_tournament'
  map.add_tournament_result  '/add_tournament_result',  :controller => 'admin', :action => 'add_tournament_result'
  map.add_participants  '/add_participants',  :controller => 'admin', :action => 'add_participants'
  map.add_participants  '/add_competition',  :controller => 'admin', :action => 'add_competition'
  map.edit_tourney '/edit_tournament/:tournament_id', :controller => 'admin', :action => 'edit_tournament'
  map.edit_user '/edit_user/:user_id', :controller => 'admin', :action => 'edit_user'
  map.add_tourney_result '/add_my_tourney_result/:tournament_id', :controller => 'admin', :action => 'add_my_tourney_result'
  map.select_tourney '/select_tourney/:tournament_id', :controller => 'admin', :action => 'select_tourney'
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "home", :action =>"home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
