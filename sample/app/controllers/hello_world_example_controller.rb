class HelloWorldExampleController < ApplicationController
  def index
    @component_name = "HelloWorldExample"
    @component_data = {
      text: "react"
    }
  end
end
