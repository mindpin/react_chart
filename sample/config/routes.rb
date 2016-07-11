Rails.application.routes.draw do
  root to: "home#index"

  get "/:controller", action: "index"
  get "/bar_chart", to: "bar_chart#index"
  get "/load_bar_chart", to: "bar_chart#load_bar_chart"
  get "/nightingale_chart", to: "nightingale_chart#index"
end
