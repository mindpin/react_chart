@ReactChart.Histogram = React.createClass
  render: ->
    <div className="histogram">
    </div>

  componentDidMount: ->
    width = 500
    height = 500

    padding = {left:30, right:30, top:20, bottom:20}

    dataset = [10,20,30,40,33,24,21,12,5, 40,20,30,15,33,10,5,40,50,11,30]

    dataSecond = ["小明","小红"]

    svg = d3.select(".histogram")
      .append("svg")
      .attr("width",width)
      .attr("height",height)

    x_scale = d3.scale.ordinal()
      .domain(d3.range(dataset.length))
      .rangeRoundBands([0, width - padding.left - padding.right])

    y_scale = d3.scale.linear()
      .domain([0, d3.max(dataset) * 1.1])
      .range([height - padding.top - padding.bottom, 0])


    x_axis = d3.svg.axis()
      .scale(x_scale)
      .orient("bottom")

    y_axis = d3.svg.axis()
      .scale(y_scale)
      .orient("left")

    tip = d3.tip()
      .attr("class","d3-tip")
      .offset([-10,0])
      .html (d)->
        d

    svg.call(tip)

    rect_padding = 4

    rects = svg.selectAll("rect")
      .data(dataset)
      .enter()
      .append("rect")
      .attr("transform","translate(#{padding.left},#{padding.top})")
      .attr("x",(d,i)->
        x_scale(i) + rect_padding / 2
      )
      .attr("y",(d)->
        y_scale(d)
      )
      .attr("width", x_scale.rangeBand() - rect_padding)
      .attr("height", (d)->
        height - padding.top - padding.bottom - y_scale(d)
      )
      .on "mouseover", (d)->
        tip.show(d)
        jQuery(".d3-tip").css("pointer-event","none")
      .on "mouseout", (d)->
        tip.hide(d)
      .attr("fill","steelblue")

    svg.append("g")
      .attr("class","axis")
      .attr("transform","translate(#{padding.left},#{height - padding.top})")
      .call(x_axis)

    svg.append("g")
      .attr("class","axis")
      .attr("transform","translate(#{padding.left},#{padding.top})")
      .call(y_axis)

    svg.selectAll(".circle")
      .data(dataSecond)
      .enter()
      .append("circle")
      .attr "cy", (d,i)->
        height - padding.top - i * 20
      .attr "cx", (d)->
        width - padding.right
      .attr("r",3)

    svg.selectAll(".text")
      .data(dataSecond)
      .enter()
      .append("text")
      .attr "dy", (d,i)->
        height - padding.top - i * 20
      .attr "dx", (d)->
       width - padding.right
      .text (d)->
        d
