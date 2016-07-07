class HelloWorldController < ApplicationController
  def index
    @component_name = "ReactChart.HelloWorld"
    @component_data = {
      text: "react"
    }
  end

  def stack_bar_chart
    react_data = {
      type: "vertical",
      bottom_name: "水果种类",
      height_name: "销售量",
      category_name: "城市",
      items: [
        {
          name: "苹果",
          nums: [
            {category_value: "北京", num: 50},
            {category_value: "上海", num: 30},
            {category_value: "广州", num: 40},
            {category_value: "杭州", num: 40}
          ]
        },
        {
          name: "香蕉",
          nums: [
            {category_value: "北京", num: 20},
            {category_value: "上海", num: 30},
            {category_value: "广州", num: 30},
            {category_value: "杭州", num: 40}
          ]
        },
        {
          name: "橘子",
          nums: [
            {category_value: "北京", num: 45},
            {category_value: "上海", num: 60},
            {category_value: "广州", num: 40},
            {category_value: "杭州", num: 40}
          ]
        }
      ]
    }
    @component_name = "ReactChart.StackBarChart"
    @component_data = react_data
  end
end
