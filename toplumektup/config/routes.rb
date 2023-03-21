=begin
/***********************************************************************
 * Copyright 2023 Turker Ozturk
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ***********************************************************************/
=end


Rails.application.routes.draw do


  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"


  resources :email_queues

  get "main/index"


  root :to => 'main#index'

  get "/main" => 'main#index'
  #match "/main/login" => 'main#login'
  # match "/main/logout" => 'main#logout'
  #match "/main/send_login" => 'main#send_login'
  #match "/tasks/" => 'tasks#index'
  #match "/tasks/new" => 'tasks#new', :as => :new_task
  #match "/tasks" => 'tasks#index'
  #match "/tasks" => 'tasks#index'

  #match "/tasks/confirm" => 'tasks#confirm'
  #match "/tasks/sendmail" => 'tasks#sendmail'
  get "/users/upload" => 'users#upload'
  get "/tasks/execute_tasks" => 'tasks#execute_tasks', :as => :execute_tasks
  get "/messages/:id/show_recipients" => 'messages#show_recipients', :as => :show_recipients
  get "/messages/gonder" => 'messages#gonder'
  get "/messages/:id/duplicate" => 'messages#duplicate', :as => :duplicate_message
  get "/users/show_and_manage_ungrouped_users" => 'users#show_and_manage_ungrouped_users', :as => :show_and_manage_ungrouped_users
  match '/users/update_ungrouped_users' => 'users#update_ungrouped_users', as: :update_ungrouped_users, via: [:post]
  get "/users/synch_eksik_evrak_group" => 'users#synch_eksik_evrak_group', :as => :synch_eksik_evrak_group
  get "/import/" => 'import#index', :as => :import_index
  get "/import/wizpage2" => 'import#wizpage2', :as => :import_wizpage2


  resources :tasks
  resources :users

  resources :groups

  resources :messages
  resources :sessions








  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
