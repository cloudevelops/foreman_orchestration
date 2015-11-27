Rails.application.routes.draw do
  resources :compute_resources, :only => [] do
    scope :module => :foreman_orchestration do
      resources :tenants, :only => [:index] do
        collection do
          get :for_select
        end
        resources :stacks, :only => [:index] do
          collection do
            delete :destroy_stack
          end
        end
      end
    end
  end
  scope :module => :foreman_orchestration do
    resources :stacks, :only => [:new, :create] do
      collection do
        get :all
      end
    end
    resources :stack_templates do
      member do
        get :with_params
      end
    end
  end
end
