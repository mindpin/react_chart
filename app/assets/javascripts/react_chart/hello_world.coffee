@ReactChart ||= {}
@ReactChart.HelloWorld = React.createClass
  render: ->
    <div className="hello-world">
      {@props.data.text}
    </div>
