Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :admin_users, except: [:new, :edit]
        post 'admin_login/login', to: 'admin_login#login'
        post 'admin_login/signup', to: 'admin_login#signup'

        get 'index_jobs', to: 'admin_users#index_jobs'
        get 'show_jobs/:id', to: 'admin_users#show_jobs'
        get 'index_recruiters', to: 'admin_users#index_recruiters'
        get 'show_recruiters/:id', to: 'admin_users#show_recruiters'
        get 'index_experts', to: 'admin_users#index_experts'
        get 'show_experts/:id', to: 'admin_users#show_experts'
      end

      resources :experts, except: [:new, :edit]
      resources :recruiters, except: [:new, :edit]
      post 'expert_login/login', to: 'expert_login#login'
      post 'expert_login/signup', to: 'expert_login#signup'

      post 'recruiter_login/login', to: 'recruiter_login#login'
      post 'recruiter_login/signup', to: 'recruiter_login#signup'

      resources :jobs, except: [:new, :edit] do
        member do
          post 'apply', to: 'jobs#apply'
        end
      end
    end
  end
end
