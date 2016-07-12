class BarChartExampleController < ApplicationController
  def index
    @component_name = "BarChartExample"
    @component_data = {
      type: "vertical",
      bottom_name: "水果种类",
      height_name: "销售量",
      item_length: 50,
      items: [
        {name: "苹果",  num: 200 },
        {name: "香蕉",  num: 120 },
        {name: "梨子",  num: 90  },
        {name: "葡萄",  num: 220 },
        {name: "北京西边的水果", num: 220 },
        {name: "橘子",  num: 50  }
      ]
    }
  end
end