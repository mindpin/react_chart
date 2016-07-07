@ReactChart ||= {}
@ReactChart.BarChart = React.createClass
  render: ->
    <div className="bar-chart">
    </div>

  getColor:(idx)->
    palette = [
      '#2ec7c9', '#b6a2de', '#5ab1ef', '#ffb980', '#d87a80',
      '#8d98b3', '#e5cf0d', '#97b552', '#95706d', '#dc69aa',
      '#07a2a4', '#9a7fd1', '#588dd5', '#f5994e', '#c05050',
      '#59678c', '#c9ab00', '#7eb00a', '#6f5553', '#c14089'
    ]
    return palette[idx % palette.length]

  componentDidMount: ->
    switch @props.data.type
      when "vertical" then @vertical_bar_chart()
      when "horizontal" then @horizontal_bar_chart()

  horizontal_bar_chart: ->
    dataset = 
      x: [],
      y: []

    for item in @props.data.items
      dataset.y.push(item.num)
      dataset.x.push(item.name)

    padding =  
      top: 100, 
      right: 100, 
      bottom: 100, 
      left: 100 

    width  = 700
    height = 600

    tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([-10, 0])
      .html (d)=>
        return "#{@props.data.bottom_name}:#{d.name}</br>#{@props.data.height_name}:#{d.data}"

    svg_g = d3.select(".bar-chart")
      .append('svg')
      .attr("width", width)
      .attr("height", height)
      .append('g')
      .classed('main', true)
      .attr('transform', "translate(" + padding.top + ',' + padding.left + ')')

    svg_g.call(tip)

    x_scale = d3.scale.ordinal()
      .domain(dataset.x)
      .rangeRoundBands([0, width - padding.left - padding.right], 0, 0)
    y_scale = d3.scale.linear()
      .domain([0, d3.max(dataset.y)])
      .range([height - padding.top - padding.bottom, 0])
    x_axis = d3.svg.axis()
      .scale(x_scale)
      .orient('bottom')
    y_axis = d3.svg.axis()
      .scale(y_scale)
      .orient('left')

    svg_g.append('g')
      .attr('class', 'axis')
      .attr('transform', 'translate(0,' + (height - padding.bottom - padding.top) + ')')
      .call(x_axis)
    svg_g.append('g')
      .attr('class', 'axis')
      .call(y_axis)

    rectMargin = 3

    svg_g.selectAll('.bar')
      .data(dataset.y)
      .enter()
      .append('rect')
      .attr "x", (d, i)->
        return x_scale(dataset.x[i]) + rectMargin
      .attr "y", (d, i)->
        y_scale(d)
      .attr "width", (d)->
        return x_scale.rangeBand() - 2 * rectMargin
      .attr "height", (d)->
        return height - padding.top - padding.bottom - y_scale(d)
      .attr "fill", (d, i)=>
        return @getColor(i)
      .on 'mouseover', (d,i)->
        tip.show
          data: dataset.y[i], 
          name: dataset.x[i]
        jQuery(".d3-tip").css("pointer-events", "none")
      .on 'mouseout', (d)->
        tip.hide(d)


    y_scale_msg = svg_g.selectAll(".y-scale-msg")
      .data([@props.data.height_name])
      .enter()
      .append("text")
      .attr "x", (d, i)->
        return x_scale(dataset.x[0]) - padding.left / 2  
      .attr "y", (d, i)->
        return (height - padding.top - padding.bottom) / 2
      .text (d)->
        return d
      .attr "transform", (d)->
        return "rotate(270,#{x_scale(dataset.x[0]) - padding.left / 2  },#{(height - padding.top - padding.bottom) / 2})"
      .attr "fill", "#888888"
      .attr "font-size", "17"


    x_scale_msg = svg_g.selectAll(".x-scale-msg")
      .data([@props.data.bottom_name])
      .enter()
      .append("text")
      .attr "x", (d, i)->
        return (height - padding.left - padding.right) /2
      .attr "y", (d, i)->
        return height - padding.top - padding.bottom + padding.bottom/2
      .text (d)->
        return d
      .attr "fill", "#888888"
      .attr "font-size", "17"

    # 右侧指示文本
    svg_g.selectAll("index-text")
      .data(dataset.x)
      .enter()
      .append("text")
      .attr("dx",  (width - padding.left - padding.right) * 1.07)
      .attr "dy", (d, i)->
        return height - padding.top - padding.bottom  - i * 20
      .text (d)->
        return d

    # 右侧指示圆点
    svg_g.selectAll('index-text-circle')
      .data(dataset.y)
      .enter()
      .append('circle')
      .attr 'cx', (d)->
        return   (width - padding.left - padding.right) * 1.05
      .attr 'cy', (d, i)->
        return height - padding.top - padding.bottom  - i * 20
      .attr('r', 5)
      .attr 'fill', (d, i)=>
        return @getColor(i)


  vertical_bar_chart: ->
    dataset = 
      x: [],
      y: [] 

    item_area_length = @props.data.item_area_length
    item_length = @props.data.item_length
    for item in @props.data.items
      dataset.x.push(item.num)
      dataset.y.push(item.name)

    # 1 设置画布和padding
    padding =  
      top: 100, 
      right: 100, 
      bottom: 100, 
      left: 100 

    width  = 700
    height = padding.top +  padding.bottom + item_area_length * dataset.x.length
    
    tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([-10, 0])
      .html (d)=>
        return "#{@props.data.bottom_name}:#{d.name}</br>#{@props.data.height_name}:#{d.data}"

    # 2 绘制画布
    svg_g = d3.select(".bar-chart")
      .append('svg')
      .attr("width", width)
      .attr("height", height)
      .append('g')
      .classed('main', true)
      .attr('transform', "translate(" + padding.top + ',' + padding.left + ')')

      svg_g.call(tip)
    
    # 3设置 x y比例尺
    x_scale = d3.scale.linear()
      .domain([0, d3.max(dataset.x)])
      .range([0, width - padding.left - padding.right])

    y_scale = d3.scale.ordinal()
      .domain(dataset.y)
      .rangeRoundBands([0, height - padding.top - padding.bottom], 0, 0)

    x_axis = d3.svg.axis()
     .scale(x_scale)      
     .orient("bottom") 

    y_axis = d3.svg.axis()
     .scale(y_scale)      
     .orient("left")

    svg_g.append("g")
      .attr("class", "axis")
      .attr('transform', 'translate(0,' + (height - padding.bottom - padding.top) + ')')
      .call(x_axis)

    svg_g.append("g")
      .attr("class", "axis")
      .call(y_axis)

    rectHeight = (item_area_length - item_length)/2
    svg_g.selectAll("rect")
      .data(dataset.x)
      .enter()
      .append("rect")
      .attr "x", (d, i)->
        return x_scale(0)
      .attr "y", (d, i)->
        return y_scale(dataset.y[i]) + rectHeight
      .attr "width", (d)->
        return x_scale(d)
      .attr "height", (d)->
        return y_scale.rangeBand() - 2 * rectHeight
      .attr "fill", (d, i)=>
        return @getColor(i)
      .on 'mouseover', (d, i)->
        tip.show
          data: d, 
          name: dataset.y[i]
        jQuery(".d3-tip").css("pointer-events", "none")
      .on 'mouseout', (d)->
        tip.hide(d)


    y_scale_msg = svg_g.selectAll(".y-scale-msg")
    .data([@props.data.bottom_name])
    .enter()
    .append("text")
    .attr "x", (d, i)->
      return x_scale(0) - padding.left / 2  
    .attr "y", (d, i)->
      return (height - padding.top - padding.bottom) / 2
    .text (d)->
      return d
    .attr "transform", (d)->
      return "rotate(270,#{x_scale(0) - padding.left / 2  },#{(height - padding.top - padding.bottom) / 2})"
    .attr "fill", "#888888"
    .attr "font-size", "17"


    x_scale_msg = svg_g.selectAll(".x-scale-msg")
    .data([@props.data.height_name])
    .enter()
    .append("text")
    .attr "x", (d, i)->
     return x_scale(d3.max(dataset.x) / 2)
    .attr "y", (d, i)->
      return height - padding.top - padding.bottom + padding.bottom / 2
    .text (d)->
      return d
    .attr "fill", "#888888"
    .attr "font-size", "17"


    # 右侧指示文本
    svg_g.selectAll("index-text")
      .data(dataset.y)
      .enter()
      .append("text")
      .attr("dx", x_scale(d3.max(dataset.x) * 1.07))
      .attr "dy", (d, i)->
        return height - padding.top - padding.bottom  - i * 20
      .text (d)->
        return d

    # 右侧指示圆点
    svg_g.selectAll('index-text-circle')
      .data(dataset.y)
      .enter()
      .append('circle')
      .attr 'cx', (d)->
        return x_scale(d3.max(dataset.x) * 1.05)
      .attr 'cy', (d, i)->
        return height - padding.top - padding.bottom  - i * 20
      .attr('r', 5)
      .attr 'fill', (d, i)=>
        return @getColor(i)




   


