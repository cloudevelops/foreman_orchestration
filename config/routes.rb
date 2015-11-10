Rails.application.routes.draw do
  scope :module => :foreman_orchestration do
    resources :stacks, only: [:index, :new, :create]
    resources :resources, only: [:index]
    resources :templates, only: [:index]
  end
end
