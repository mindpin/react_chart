module ReactChart
  class ApplicationController < ActionController::Base
    layout "react_chart/application"

    if defined? PlayAuth
      helper PlayAuth::SessionsHelper
    end
  end
end