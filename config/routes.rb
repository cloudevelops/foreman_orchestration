Rails.application.routes.draw do
  scope :module => :foreman_orchestration do
    resources :stacks, only: [:index, :new, :create] do
      collection do
        get :for_tenant
      end
    end
    resources :resources, only: [:index]
    resources :templates, only: [:index]
  end
end
