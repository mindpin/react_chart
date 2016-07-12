@StackBarChartExample = React.createClass
  render: ->
    <div className="stack-bar-chart-example">
      <ReactChart.StackBarChart data={@props.data}/>
    </div>
