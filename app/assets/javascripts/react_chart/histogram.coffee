@ReactChart.Histogram = React.createClass
  
  color: (i)->
    colors = ["steelblue", "#10FF33", "#4CC0FF", "#7843E8", "#5EFF88", "#A18FFF"]
    colors[i % colors.length]

  # 将数据转换成堆叠图所需格式
  conversion_data_form: (dataset)->
    course_ary = []
    for typle in dataset
      score_num = []
      for i in [0...typle.length]
        score_hash = {
          x: i, y: typle[i].y
        }
        score_num.push(score_hash)
      course_ary.push(score_num)
    course_ary

  # 将成绩按区间计数
  dataset_digital_to_histogram: (data_ary)->
    grades_ary = []
    bin_num = 10
    histogram = d3.layout.histogram()
      .range([0, 100])
        .bins(bin_num)
      .frequency(true)
    for category in data_ary
      data_num = histogram(category.nums)
      grades_ary.push(data_num)
    grades_ary


  # set_display_course_info: (y0, ele_y, location)->
  #   if ele[num].y0 == 0
  #     course_name = @props.data.items[0].name
  #     msg += course_name + ": " + ele[num].y + "</br>"

  # # 设置显示提示框信息
  # set_display_tip_info: (num, dataset)->
  #   msg = ""
  #   console.log dataset
  #   for ele in dataset
  #     if ele[num].y0 == 0
  #       course_name = @props.data.items[0].name
  #       msg += course_name + ": " + ele[num].y + "</br>"
  #     if ele[num].y0 == ele[]
  #       course_name = @props.data.items[1].name
  #       msg += course_name + ": " + ele[num].y + "</br>"
      
  #   msg


  render: ->
    <div className="histogram">
    </div>

  componentDidMount: ->
    width = 600
    height = 600

    # 生成画布
    svg = d3.select(".histogram")
      .append("svg")
      .attr("width", width)
      .attr("height", height)

    # 将科目名 push 进一个数组中
    data_second = []
    course_name_length = []
    for course in @props.data.items
      data_second.push(course.name)
      course_name_length.push(course.name.length)
    # 右间距为课程名的长度乘于 16 像素(16 像素为浏览器中字体的默认像素) ↓
    # 加上 4 (4 为右侧显示圆点的直径)加上15 ↓
    # (15 为圆点与课程名之间的预留间隔像素)
    padding = {left:40, right: d3.max(course_name_length) * 16 + 4 + 15, top:30, bottom:30}

    # 将分数按区间计数
    grades_ary = @dataset_digital_to_histogram(@props.data.items)
    # 将各个科目的各个区间成绩所占数目转换成堆叠图所需数据格式
    dataset = @conversion_data_form(grades_ary)
    # 初始化堆叠布局函数，并把原始数据传进去，生成堆叠数据
    stack = d3.layout.stack()
    stack(dataset)

    # y 轴矩形比例尺
    y_scale = d3.scale.linear()
      .domain([0, 
        d3.max(dataset, (d)->
          d3.max(d, (d)->
            d.y0 + d.y
          )
        )
      ])
      .range([0, height - padding.top - padding.bottom])

    # y 轴坐标比例尺 
    y_scale_coordinate = d3.scale.linear()
      .domain([0, 
        d3.max(dataset, (d)->
          d3.max(d, (d)->
            d.y0 + d.y
          )
        )
      ])
      .range([height - padding.top - padding.bottom, 0])

    # x 轴矩形比例尺
    x_scale = d3.scale.ordinal()
      .domain(d3.range(dataset[0].length))
      .rangeRoundBands([40, width - padding.right])
    # x 轴坐标比例尺
    data_x_coordinate = ['0-10', '10-20', '20-30', '30-40', '40-50', '50-60', '60-70', '70-80', '80-90', '90-100']
    r_scale = d3.scale.ordinal()
      .domain(data_x_coordinate) 
      .rangeRoundBands([0, width - padding.right - padding.left])     

    # 设置提示
    tip = d3.tip()
      .attr("class", "d3-tip")
      .offset([-5,0])
      .html (d, i)=>
        switch d.x
          when 0 
            msg = ""
            for ele in dataset
              console.log ele[0]
              if ele[0].y0 == 0
                course_name = @props.data.items[0].name
                msg += course_name + ": " + ele[0].y + "</br>"
              if ele[0].y0 == ele[0].y
                course_name = @props.data.items[1].name
                msg += course_name + ": " + ele[1].y + "</br>"

            "<span>#{msg}</span>"
            
          # when 1
          # when 2
          # when 3
          # when 4
          # when 5
          # when 6
          # when 7
          # when 8
          # when 9

    svg.call(tip)

    # 开始绘制堆叠图
    groups = svg.selectAll("g")
      .data(dataset)
      .enter()
      .append("g")
      .attr "fill", (d, i)=>
        @color(i)

    # 绘制堆叠图
    groups.selectAll("rect")
      .data((d)->
        d
      )
      .enter()
      .append("rect")
      .attr("x", (d,i)->
        x_scale(i)
      )
      .attr("y", (d)->
        height - padding.top  - y_scale(d.y0) - y_scale(d.y)
      )
      .attr("height", (d)->
        y_scale(d.y)
      )
      .attr("width", x_scale.rangeBand())
      .on "mouseover", (d, i)->
        tip.show(d)
          .style("left", "#{d3.event.pageX + 15}px")
          .style("top", "#{d3.event.pageY}px")
        jQuery(".d3-tip").css("pointer-events", "none")
      .on "mousemove", (d)->
        tip.style("left", "#{d3.event.pageX + 15}px")
          .style("top", "#{d3.event.pageY}px")
      .on "mouseout", (d)->
        tip.hide(d)

    # 设置 y 轴坐标
    y_axis = d3.svg.axis()
      .scale(y_scale_coordinate)
      .orient("left")
    # 设置 x 轴坐标
    x_axis = d3.svg.axis()
      .scale(r_scale)
      .orient("bottom")

    # 画 y 轴刻度
    svg.append("g")
      .attr("class", "axis")
      .attr("transform", "translate(#{padding.left - 1}, #{padding.top})")
      .call(y_axis)
      .append("text")
      .text(@props.data.height_name)
      .attr("transform","translate(-20, -10)")
    # 画 x 轴刻度 
    svg.append("g")
      .attr("class", "axis")
      .attr("transform", "translate(#{padding.left}, #{height - padding.bottom})")
      .call(x_axis)
      .append("text")
      .text(@props.data.bottom_name)
      .attr("transform", "translate(#{width - padding.right - padding.left}, 10)")

    # 设置右侧导读
      # 表示色的圆点
    svg.selectAll(".circle")
      .data(data_second)
      .enter()
      .append("circle")
      .attr "cy", (d,i)->
        height - padding.bottom - 20 - i * 20
      .attr "cx", (d)->
        width - padding.right + 10
      .attr("r", 4)
      .attr "fill", (d,i)=>
        @color(i)

      # 罗列科目
    svg.selectAll(".text")
      .data(data_second)
      .enter()
      .append("text")
      .attr("class", ".text")
      .attr "dy", (d,i)->
        height - padding.bottom - 15 - i * 20
      .attr "dx", (d)->
       width - padding.right + 15
      .text (d)->
        d

    # 右侧导读标题
    category = []
    category.push(@props.data.category_name)
    svg.selectAll(".category-text")
      .data(category)
      .enter()
      .append("text")
      .attr("class", ".category-text")
      .attr("dx", (d,i)->
        width - padding.right + 3
      )
      .attr("dy", (d)->
        height - padding.bottom - 140
      )
      .text (d)->
        d
      .style("font-size", "20px")
