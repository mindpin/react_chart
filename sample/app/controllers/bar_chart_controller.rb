class BarChartController < ApplicationController
  def index
    @component_name = "ReactChart.BarChart"
    @component_data = {
      type: "vertical",
      bottom_name: "水果种类",
      height_name: "销售量",
      item_length: 50,
      item_area_length: 120,
      items: [
        {name: "苹果",  num: 200 },
        {name: "香蕉",  num: 120 },
        {name: "梨子",  num: 90  },
        {name: "葡萄",  num: 220 },
        {name: "葡萄1", num: 220 },
        {name: "橘子",  num: 50  }
      ]
    }
  end

  def load_bar_chart
    @component_name = "ReactChart.LoadBarChart"
    @component_data = {
      type: "vertical",
      bottom_name: "水果种类",
      height_name: "销售量",
      item_length: 40,
      items: [
        {name: "苹果",  num: 200 },
        {name: "香蕉",  num: 120 },
        {name: "梨子",  num: 90  },
        {name: "葡萄",  num: 220 },
        {name: "葡萄1234", num: 220 },
        {name: "橘子",  num: 50  }
      ]
    }
  end
end