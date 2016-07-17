@ReactChart ||= {}
@ReactChart.NightingaleChart = React.createClass
  render: ->
    <div className="nightingale_chart">
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
    width = 500
    height = 500

    radius = Math.min(width, height) / 2
    innerRadius = 0.3 * radius


    pie = d3.layout.pie()
      .sort(null)
      .value (d)->
        return d.width

    tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([0, 0])
      .html (d)->
        return d.data.label + ": <span style='color:orangered'>" + d.data.score + "</span>"

    arc = d3.svg.arc()
      .innerRadius(innerRadius)
      .outerRadius (d)->
        return (radius - innerRadius) * (d.data.score / 100.0) + innerRadius

    outlineArc = d3.svg.arc()
      .innerRadius(innerRadius)
      .outerRadius(radius)

    svg = d3.select(".nightingale_chart").append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

    svg.call(tip)

    data = []


    console.log @props.data

    for item in  @props.data.items
      hash = {}
      hash["score"] = item.num
      hash["label"] = item.name
      hash["width"] = 10
      data.push(hash)

    pie_data = pie(data)
 
    path = svg.selectAll(".solidArc")
      .data(pie(data))
      .enter()
      .append("path")
      .attr "fill", (d, i)=>
        return @getColor(i)
      .attr("class", "solidArc")
      .attr("stroke", "gray")
      .attr("d", arc)
      .on('mouseover', tip.show)
      .on('mouseout', tip.hide)


      texts =  svg.selectAll(".arc-text")
      .data(pie(data))
      .enter()
      .append("text")
      .attr "transform", (d, i)->
        x = arc.centroid(d)[0] * 1.1
        y = arc.centroid(d)[1] * 1.1
        return "translate(" + x + "," + y + ")"
      .attr 'fill', (d, i)=>
        return "black"
      .text (d)->
        return d.data.label

      texts =  svg.selectAll(".arc-text")
      .data(pie(data))
      .enter()
      .append("text")
      .attr "transform", (d, i)->
        x = arc.centroid(d)[0] * 1.1
        y = arc.centroid(d)[1] * 1.1
        console.log((radius - innerRadius) * (d.data.score / 100.0) + innerRadius)
        return "translate(" + x + "," + y + ")"
      .attr 'fill', (d, i)=>
        return "black"
      .text (d)->
        return d.data.label

      num_texts =  svg.selectAll(".num-text")
      .data(pie(data))
      .enter()
      .append("text")
      .attr "transform", (d, i)->
        x = arc.centroid(d)[0] * 2 - 
        y = arc.centroid(d)[1] * 2 -

        console.log(d.startAngle)
        console.log(d.endAngle)
        # 前两者除以二 再算上外圈的长度
        return "translate(" + x + "," + y + ")"
      .attr 'fill', (d, i)=>
        return "black"
      .text (d)->
        return d.data.score



    outerPath = svg.selectAll(".outlineArc")
      .data(pie(data))
      .enter().append("path")
      .attr("fill", "none")
      .attr("stroke", "gray")
      .attr("class", "outlineArc")
      .attr("d", outlineArc)




    # svg.append("svg:text")
    # .attr("dy", ".35em")
    # .attr("text-anchor", "middle")
    # .text(Math.round(100));















