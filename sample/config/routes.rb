Rails.application.routes.draw do
  root to: "home#index"

  get "/:controller", action: "index"
  get "/stack_bar_chart", to: "hello_world#stack_bar_chart"
end
