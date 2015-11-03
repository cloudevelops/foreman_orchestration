Rails.application.routes.draw do
  get 'new_action', to: 'foreman_orchestration/hosts#new_action'
end
