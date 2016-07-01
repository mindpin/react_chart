Rails.application.routes.draw do
  root to: "home#index"

  get "/:controller", action: "index"

  get "/histogram", to: "index#histogram"
end
