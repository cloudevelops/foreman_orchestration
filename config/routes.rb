Rails.application.routes.draw do
  scope :module => :foreman_orchestration do
    resources :stacks, only: [:index, :new, :create] do
      collection do
        get :for_tenant
        get :params_for_template
        delete :destroy_stack
      end
    end
    resources :resources, only: [:index]
    resources :stack_templates
  end
end
