module.exports = lemon.Component {
  package: 'site'
  name: 'DataBinding'

  data: {
    output: 0
  }

  methods: {
    onClick: (event) ->
      @output = Math.random()
  }

  template: (data) ->
    button $click: 'onClick', ->
      "Click Me"

    div bind: {text: 'output'}
    div _text: 'output'
    div _on: 'output', _template: (output) ->
      span -> "[#{output}]"

}
