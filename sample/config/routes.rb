Rails.application.routes.draw do
  root to: "home#index"

  get "/:controller", action: "index"
  get "/bar_chart", to: "bar_chart#index"
end
