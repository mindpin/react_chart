@ReactChart ||= {}
@ReactChart.StackBarChart = React.createClass
  render: ->
    <div className="stack-bar-chart">
    </div>

  add_tip: (height,city_array,fruit_name_array,fruit_nums)->
    tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([height/6,0])
      .html (d)->
        for i in [0..city_array.length - 1]
          if city_array[i] == d.x
            data_str = ""
            for j in [0..fruit_name_array.length - 1]
              data_str = data_str + "<li>" + fruit_name_array[j] + ":" + fruit_nums[j][i].y + "</li>"         
        return "<div>" + d.x + "</div>" + "<ul>" + data_str + "</ul>"

  add_svg: (width,height)->
    svg = d3.select(".stack-bar-chart")
      .append("svg")
      .attr("width", width)
      .attr("height", height)

  add_fruit_color_tags: (svg,fruit_nums,colors,width,height,padding_left,padding_bottom)->
    svg.selectAll("circle")
      .data(fruit_nums)
      .enter()
      .append("circle")
      .attr("class", "circle")
      .attr("cx", width - padding_left)
      .attr("cy", 
        (d,i)->
          return height - 20 * i - padding_bottom*2 
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
      .attr("x", width - padding_left + 5)
      .attr("y",
        (d,i)->
          return height - 20 * i  - padding_bottom*2 + 5
      )
      .text(
        (d)->
          return d.name
      )

  ordinal_scale:(range,start,end)->
    d3.scale.ordinal()
      .domain(range)
      .rangeRoundBands([start,end],0.5)

  linear_scale: (dataset,start,end)->
    d3.scale.linear()
      .domain([0, 
        d3.max(dataset,
          (d)->
            return d3.max(d,
              (d)->
                return d.y0 + d.y
            )
        )
      ])
      .range([start, end])
  
  add_xAxis: (svg,rScale,end)->
    xAxis = d3.svg.axis()
        .scale(rScale)
        .orient("bottom")

    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0,#{end})")
      .call(xAxis) 

    x_axis = jQuery(".stack-bar-chart .x .tick text")
    x_axis.attr("class","123").attr("transform", "rotate(340, 0, 0)")

  add_yAxis: (svg,yScale,start)->
    yAxis = d3.svg.axis()
      .scale(yScale)
      .orient("left")

    svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(#{start},0)")
      .call(yAxis)

    y_axis = jQuery(".stack-bar-chart .y .tick text")
    y_axis.attr("class","123").attr("transform", "rotate(330, 0, 0)")

  componentDidMount: ->
    #绘制层叠柱状图的数据
    fruit_nums = []
    for item in @props.data.items
      fruit = []
      for sale_data in item.nums
        sale_data = 
          x: sale_data.category_value
          y: sale_data.num
        fruit.push(sale_data)
      fruit_nums.push(fruit)

    stack = d3.layout.stack()
    stack(fruit_nums)
    
    #城市数组
    city_array = []
    for sale_data in @props.data.items[0].nums
      city_array.push(sale_data.category_value)

    #水果数组
    fruit_name_array = []
    for item in @props.data.items
      fruit_name_array.push(item.name)

    width = jQuery(".stack-bar-chart").width()
    height = jQuery(".stack-bar-chart").height()
    rem = parseInt(jQuery(".stack-bar-chart").css("font-size"))

    colors = d3.scale.category10()

    #设置边距
    padding = {left:rem*3, right:10 + rem*3, top:50, bottom:rem*2}

    #添加svg
    svg = @add_svg(width,height)

    # 增加tip信息
    tip = @add_tip(height,city_array,fruit_name_array,fruit_nums)
    svg.call(tip)
    
    #添加水果类别的颜色提示
    @add_fruit_color_tags(svg,fruit_nums,colors,width,height,padding.left,padding.bottom)


    # 水平绘制
    if @props.data.type == "horizontal"

      #添加水果类别的颜色提示标签
      @add_fruit_color_tags(svg,fruit_nums,colors,width,height,padding.left,padding.bottom) 

      #设置y轴比例尺
      yScale = @ordinal_scale(d3.range(fruit_nums[0].length),height - padding.bottom,padding.top)

      #设置y轴的刻度
      rScale = @ordinal_scale(city_array,height - padding.bottom,padding.top)
      
      #设置x轴比例尺
      xScale = @linear_scale(fruit_nums,padding.left,width - padding.right)

      #绘制层叠柱状图  
      groups = svg.selectAll("g")
        .data(fruit_nums)
        .enter()
        .append("g")
        .style("fill", 
          (d,i)->
            return colors(i)
        )

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

      #添加x轴
      @add_xAxis(svg,xScale,height - padding.bottom)

      #绘制y轴
      @add_yAxis(svg,rScale,padding.left)

    # 垂直绘制
    if @props.data.type == "vertical"
      #添加水果类别的颜色提示标签
      @add_fruit_color_tags(svg,fruit_nums,colors,width,height,padding.left,padding.bottom)
      
      #设置x轴的比例尺
      xScale = @ordinal_scale(d3.range(fruit_nums[0].length),padding.left,width - padding.right)
 
      #设置x轴的刻度
      rScale = @ordinal_scale(city_array,padding.left,width - padding.right)

      #设置y轴的比例尺
      yScale = @linear_scale(fruit_nums,height - padding.bottom,padding.top)

      #绘制层叠柱状图
      groups = svg.selectAll("g")
        .data(fruit_nums)
        .enter()
        .append("g")
        .style("fill", 
          (d,i)->
            return colors(i)
        )

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

      #绘制x轴
      @add_xAxis(svg,rScale,height - padding.bottom)

      #绘制y轴
      @add_yAxis(svg,yScale,padding.left)