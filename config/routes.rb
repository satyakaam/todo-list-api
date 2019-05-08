# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :tasks, except: [:new, :edit]     
      resources :tags, except: [:new, :edit]     
    end
  end
end
