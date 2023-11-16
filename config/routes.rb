Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
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
