class HistogramController < ApplicationController
  def index
    @component_name = "ReactChart.Histogram"
    @react_data = {
      bottom_name: "成绩",
      height_name: "人数",
      category_name: "科目",
      items: [
        {
            name: "语文",
            nums: random_num()
        }, {
            name: "化学",
            nums: random_num()
        }, {
            name: "数学",
            nums: random_num()
        }, {
            name: "英语",
            nums: random_num()
        }, {
            name: "生物",
            nums: random_num()
        }, {
            name: "物理",
            nums: random_num()
        }
      ]
    }
  end

  private 
    def random_num
        dataset = []
        for num in 0...100
          dataset.push( Random.rand(100) )
        end
        dataset
    end
end
