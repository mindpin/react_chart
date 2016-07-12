Rails.application.routes.draw do
  root to: "home#index"

  get "/:controller", action: "index"
end
