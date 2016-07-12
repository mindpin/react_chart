@HistogramExample = React.createClass
  render: ->
    <div className="histogram-example">
      <ReactChart.Histogram data={@props.data}/>
    </div>