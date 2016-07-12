Rails.application.routes.draw do
  root to: "home#index"

  get "/:controller", action: "index"

  get "/histogram", to: "histogram#index"
  get "/histogram_example", to:"histogram#histogram_example"
end
