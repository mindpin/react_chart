@ReactChart ||= {}
@ReactChart.HistogramFather = React.createClass
  render: ->
    <div className="histogram-father">
      <ReactChart.Histogram data={@props.data}/>
    </div>