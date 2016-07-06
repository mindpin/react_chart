@ReactChart.Histogram = React.createClass
  
  color: (i)->
    colors = ["steelblue","#10FF33","#4CC0FF","#7843E8","#5EFF88","#A18FFF"]
    colors[i % colors.length]

  conversion_data_form: (dataset)->
    course_ary = []
    for typle in dataset
      score = []
      for ele in typle.nums
        score_hash = {
          x: typle.nums.indexOf(ele), y: ele
        }
        score.push(score_hash)
      course_ary.push(score)
    course_ary

  render: ->
    <div className="histogram">
    </div>

  componentDidMount: ->
    width = 1000
    height = 600

    padding = {left:40, right:40, top:30, bottom:30}

    data_second = []
    for course in @props.data.items
      data_second.push(course.name)

    svg = d3.select(".histogram")
      .append("svg")
      .attr("width",width)
      .attr("height",height)

    dataset = @conversion_data_form(@props.data.items)

    stack = d3.layout.stack()
    stack(dataset)

    # 设置比例尺
    y_scale = d3.scale.linear()
      .domain([0, 
        d3.max(dataset, (d)->
          d3.max(d,(d)->
            d.y0 + d.y
          )
        )
      ])
      .range([0, height - padding.top - padding.bottom])

    y_axis_scale = d3.scale.linear()
      .domain([0, 
        d3.max(dataset, (d)->
          d3.max(d,(d)->
            d.y0 + d.y
          )
        )
      ])
      .range([height - padding.top - padding.bottom, 0])

    x_scale = d3.scale.ordinal()
      .domain(d3.range(dataset[0].length))
      .rangeRoundBands([40, width - padding.left - padding.left - padding.right])

    r_scale = d3.scale.ordinal()
      .domain([0,10,20,30,40,50,60,70,80,90,100])
      .rangeRoundBands([40, width - padding.left - padding.left - padding.right])

    # 设置提示
    tip = d3.tip()
      .attr("class","d3-tip")
      .offset([-5,0])
      .html (d)->
        "<span style='color:red'>#{d.y}</span>"

    svg.call(tip)

    groups = svg.selectAll("g")
      .data(dataset)
      .enter()
      .append("g")
      .attr "fill", (d, i)=>
        @color(i)
    # 层叠图
    rects = groups.selectAll("rect")
      .data((d)->
        d
      )
      .enter()
      .append("rect")
      .attr("x",(d,i)->
        x_scale(i)
      )
      .attr("y",(d)->
        height - padding.top  - y_scale(d.y0) - y_scale(d.y) 
      )
      .attr("height",(d)->
        y_scale(d.y)
      )
      .attr("width", x_scale.rangeBand())
      .on "mouseover", (d)->
        tip.show(d)
      .on "mouseout", (d)->
        tip.hide(d)

    x_axis = d3.svg.axis()
      .scale(r_scale)
      .orient("bottom")

    # 设置 y 轴坐标
    y_axis = d3.svg.axis()
      .scale(y_axis_scale)
      .orient("left")

    svg.append("g")
      .attr("class","axis")
      .attr("transform","translate(#{padding.left},#{padding.top})")
      .call(y_axis)

    svg.append("g")
      .attr("class","axis")
      .attr("transform","translate(0,#{height - padding.top})")
      .call(x_axis)

    # 设置右侧注释
    svg.selectAll(".circle")
      .data(data_second)
      .enter()
      .append("circle")
      .attr "cy", (d,i)->
        height - padding.bottom - 10 - i * 20
      .attr "cx", (d)->
        width - padding.right - 10
      .attr("r",4)
      .attr "fill", (d,i)=>
        @color(i)

    svg.selectAll(".text")
      .data(data_second)
      .enter()
      .append("text")
      .attr "dy", (d,i)->
        height - padding.bottom - 10 - i * 20
      .attr "dx", (d)->
       width - padding.right - 10
      .text (d)->
        d