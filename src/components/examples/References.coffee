module.exports = lemon.Component {
  package: 'site'
  name: 'References'

  methods: {
    onClick: (event) ->
      @$target.innerText = Math.random()
  }

  template: (data) ->
    button $click: 'onClick', ->
      "Click Me"

    div ref: '$target'

}
