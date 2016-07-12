@HelloWorldExample = React.createClass
  render: ->
    <div className="hello-world-example">
      <ReactChart.HelloWorld data={@props.data} />
    </div>
