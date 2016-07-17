@BarChartExample = React.createClass
  render: ->
    <div className="load-bar-chart">
      <div className="area1">
        <ReactChart.BarChart data={@props.data}/>
      </div>
    </div>