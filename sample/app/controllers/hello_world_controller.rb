class HelloWorldController < ApplicationController
  def index
    @component_name = "ReactChart.HelloWorld"
    @component_data = {
      text: "react"
    }
  end

  def stack_bar_chart
    react_data = {
      type: "horizontal",
      bottom_name: "水果种类",
      height_name: "销售量",
      category_name: "城市",
      items: [
        {
          name: "苹果",
          nums: [
            {category_value: "北京", num: 50},
            {category_value: "上海", num: 30}
          ]
        },
        {
          name: "橘子",
          nums: [
            {category_value: "北京", num: 45},
            {category_value: "上海", num: 60}
          ]
        }
      ]
    }
    @component_name = "ReactChart.StackBarChart"
    @component_data = react_data
  end
end
