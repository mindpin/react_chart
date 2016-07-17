class NightingaleChartController < ApplicationController
  def index
    @component_name = "ReactChart.NightingaleChart"
    @component_data = {
      type: "single",
      items: [
        {name: "苹果", num: 100},
        {name: "香蕉", num: 40},
        {name: "萝卜", num: 30},
        {name: "葡萄", num: 10},
        {name: "西瓜", num: 50},
        {name: "香梨", num: 60},
        {name: "凤梨", num: 70},
        {name: "桃子", num: 80},
        {name: "橘子", num: 20}
      ]
    }
  end
end