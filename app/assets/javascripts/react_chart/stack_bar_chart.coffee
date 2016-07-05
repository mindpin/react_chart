@ReactChart ||= {}
@ReactChart.StackBarChart = React.createClass
  render: ->
     <div className="stack-bar-chart">
     </div>

  componentDidMount: ->
     a = [
      { x: "北京", y: 5 },
      { x: "上海", y: 4 },
      { x: "广州", y: 2 },
     ]
     b = [
      { x: "北京", y: 12 },
      { x: "上海", y: 0 },
      { x: "广州", y: 16 },
     ]
     c = [
      { x: "北京", y: 6 },
      { x: "上海", y: 15 },
      { x: "广州", y: 14 },
     ]

     dataset = [a,b,c]
     width = 500
     height = 600
     padding = {left:50, right:50, top:50, bottom:50}
     colors = d3.scale
       .category10()


     tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([-10, 0])
      .html (d)->
        return d.x + ":" + d.y

     svg = d3.select(".stack-bar-chart")
      .append("svg")
      .attr("width", width)
      .attr("height", height)

     stack = d3.layout.stack()

     stack(dataset)
     # 在y轴上绘制
     # yScale = d3.scale.ordinal()
     #   .domain(d3.range(dataset[0].length))
     #   .rangeRoundBands([padding.bottom,height - padding.top],0.05)

     # rScale = d3.scale.ordinal()
     #   .domain(d3.range(["","北京","上海","广州",""]))
     #   .range([padding.bottom, 117, 248, 379, height - padding.top],0.05)

     # xScale = d3.scale.linear()
     #   .domain([0,
     #     d3.max(dataset,
     #       (d)->
     #         return d3.max(d,
     #           (d)->
     #             return d.y0 + d.y
     #         )
     #     )
     #   ])
     #   .range(width - padding.left, padding.right)

     # xAxis = d3.svg.axis()
     #  .scale(yScale)
     #  .orient("bottom")

     # yAxis = d3.svg.axis()
     #  .scale(rScale)
     #  .orient("left")

     # svg.append("g")
     #  .attr("class", "x axis")
     #  .attr("transform", "translate(0,550)")
     #  .call(xAxis)
      
     # svg.append("g")
     #  .attr("class", "y axis")
     #  .attr("transform", "translate(50,0)")
     #  .text(
     #    (d)->
     #      return d
     #  )
     #  .call(yAxis)
     
     #在x轴上绘制
     xScale = d3.scale.ordinal()
      .domain(d3.range(dataset[0].length))
      .rangeRoundBands([padding.left, width - padding.right],0.05)

     rScale = d3.scale.ordinal()
      .domain(["","北京","上海","广州",""])
      .range([padding.left,117, 248,379,width - padding.right],0.05)

     yScale = d3.scale.linear()
      .domain([0, 
        d3.max(dataset,
          (d)->
            return d3.max(d,
              (d)->
                return d.y0 + d.y
            )
        )
      ])
      .range([height - padding.bottom, padding.top])

     xAxis = d3.svg.axis()
      .scale(rScale)
      .orient("bottom")

     yAxis = d3.svg.axis()
      .scale(yScale)
      .orient("left")
     
     groups = svg.selectAll("g")
      .data(dataset)
      .enter()
      .append("g")
      .style("fill", 
        (d,i)->
          return colors(i)
      )

     svg.call(tip)

     rects = groups.selectAll("rect")
      .data(
        (d)->
          return d
      )
      .enter()
      .append("rect")
      .attr("x",
        (d,i)->
          return xScale(i)
      )
      .attr("y",
        (d)->
          return height + padding.bottom - (height - yScale(d.y0)) - (height - yScale(d.y))
      )
      .attr("height",
        (d)->
          return height - padding.bottom - yScale(d.y)
      )
      .attr("width", xScale.rangeBand())
      .text(
        (d)->
          return height - yScale(d.y)
      )
      .on "mouseover", (d)->
        tip.show(d, yScale(d.y))
      .on "mouseout", (d)->
        tip.hide(d)

     svg.selectAll("circle")
      .data(dataset)
      .enter()
      .append("circle")
      .attr("class", "circle")
      .attr("cx", width - 40)
      .attr("cy", 
        (d,i)->
          return height - 20 * i - padding.bottom
      )
      .attr("r", 5)
      .style("fill", 
        (d,i)->
          return colors(i)
      )

     svg.selectAll("text")
      .data(dataset)
      .enter()
      .append("text")
      .attr("class", "text")
      .attr("x", width - 35)
      .attr("y",
        (d,i)->
          return height - 20 * i  - 45
      )
      .text(
        (d,i)->
          switch i
            when 0
              return "苹果"
            when 1
              return "香蕉"
            when 2
              return "橘子"
      )

     svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0,550)")
      .text(
        (d)->
          return d
      )
      .call(xAxis)
      
     svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(50,0)")
      .call(yAxis)
