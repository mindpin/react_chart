@StackBarChartPage = React.createClass
  render: ->
    <div className="stack-bar-chart-page">
      <StackBarChart className="stack-bar-chart" data={@props.data}/>
    </div>
