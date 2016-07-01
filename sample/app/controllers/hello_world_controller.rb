class HelloWorldController < ApplicationController
  def index
    @component_name = "ReactChart.HelloWorld"
    @component_data = {
      text: "react"
    }
  end
end
