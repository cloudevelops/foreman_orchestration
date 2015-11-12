Rails.application.routes.draw do
  scope :module => :foreman_orchestration do
    resources :stacks, only: [:index, :new, :create] do
      collection do
        get :for_tenant
      end
    end
    resources :resources, only: [:index]
    resources :stack_templates do
      collection do
        get :with_params
      end
    end
  end
end
