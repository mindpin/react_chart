@ReactChart ||= {}
@ReactChart.StackBarChart = React.createClass
  render: ->
    <div className="stack-bar-chart">
    </div>

  componentDidMount: ->
    fruit_nums = []
    for item in @props.data.items
      fruit = []
      for sale_data in item.nums
        sale_data = 
          x: sale_data.category_value
          y: sale_data.num
        fruit.push(sale_data)
      fruit_nums.push(fruit)

    city_array = []
    for sale_data in @props.data.items[0].nums
      city_array.push(sale_data.category_value)


    fruit_name_array = []
    for item in @props.data.items
      fruit_name_array.push(item.name)

    width = 500
    height = 600
    padding = {left:50, right:50, top:50, bottom:50}
    colors = d3.scale.category10()
    

    tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([100,0])
      .html (d)->
        for i in [0..city_array.length - 1]
          if city_array[i] == d.x
            data_str = ""
            for j in [0..fruit_name_array.length - 1]
              data_str = data_str + "<li>" + fruit_name_array[j] + ":" + fruit_nums[j][i].y + "</li>"         
        return "<div>" + d.x + "</div>" + "<ul>" + data_str + "</ul>" 

    svg = d3.select(".stack-bar-chart")
      .append("svg")
      .attr("width", width)
      .attr("height", height)

    stack = d3.layout.stack()

    stack(fruit_nums)

    if @props.data.type == "vertical"
      # 在y轴上绘制
      yScale = d3.scale.ordinal()
        .domain(d3.range(fruit_nums[0].length))
        .rangeRoundBands([padding.bottom,height - padding.top],0.05)

      rScale = d3.scale.ordinal()
        .domain(city_array)
        .rangeRoundBands([padding.bottom,height - padding.top],0.05)

      xScale = d3.scale.linear()
        .domain([0, 
          d3.max(fruit_nums,
            (d)->
              return d3.max(d,
                (d)->
                  return d.y0 + d.y
              )
          )
        ])
        .range([padding.left, width - padding.right])

      xAxis = d3.svg.axis()
        .scale(xScale)
        .orient("bottom")

      yAxis = d3.svg.axis()
        .scale(rScale)
        .orient("left")

      groups = svg.selectAll("g")
        .data(fruit_nums)
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
          (d)->
            return  xScale(d.y0)
        )
        .attr("y",
          (d,i)->
            return yScale(i)
        )
        .attr("height", yScale.rangeBand())
        .attr("width", 
          (d)->
            return xScale(d.y) - padding.left
        )
        .text(
          (d)->
            return xScale(d.y)
        )
        .on "mouseover", (d)->
          tip.show(d)
          jQuery(".d3-tip").css("pointer-events", "none")
        .on "mouseout", (d)->
          tip.hide(d)

      svg.selectAll("circle")
        .data(fruit_nums)
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
        .data(@props.data.items)
        .enter()
        .append("text")
        .attr("class", "text")
        .attr("x", width - 35)
        .attr("y",
          (d,i)->
            return height - 20 * i  - 45
        )
        .text(
          (d)->
            return d.name
        )

      svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0,#{height - padding.bottom })")
        .call(xAxis)
        
      svg.append("g")
        .attr("class", "y axis")
        .attr("transform", "translate(#{padding.left},0)")
        .text(
          (d)->
            return d
        )
        .call(yAxis)
    if @props.data.type == "horizontal"
      # 在x轴上绘制
      xScale = d3.scale.ordinal()
        .domain(d3.range(fruit_nums[0].length))
        .rangeRoundBands([padding.left, width - padding.right],0.05)

      rScale = d3.scale.ordinal()
        .domain(city_array)
        .rangeRoundBands([padding.left, width - padding.right],0.05)

      yScale = d3.scale.linear()
        .domain([0, 
          d3.max(fruit_nums,
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
        .data(fruit_nums)
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
          tip.show(d)
          jQuery(".d3-tip").css("pointer-events", "none")
        .on "mouseout", (d)->
          tip.hide(d)

      svg.selectAll("circle")
        .data(fruit_nums)
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
        .data(@props.data.items)
        .enter()
        .append("text")
        .attr("class", "text")
        .attr("x", width - 35)
        .attr("y",
          (d,i)->
            return height - 20 * i  - 45
        )
        .text(
          (d)->
            return d.name
        )

      svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + (height - padding.bottom) + ")")
        .text(
          (d)->
            return d
        )
        .call(xAxis)
        
      svg.append("g")
        .attr("class", "y axis")
        .attr("transform", "translate(" + padding.left + ",0)")
        .call(yAxis)
