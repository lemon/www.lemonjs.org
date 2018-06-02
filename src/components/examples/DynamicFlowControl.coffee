module.exports = lemon.Component {
  package: 'site'
  name: 'DynamicFlowControl'

  data: {
    items: ['a', 'b']
    visible: true
  }

  methods: {
    update: ->
      @visible = not @visible
  }

  template: ->

    button $click: 'update', ->
      "Click to toggle visible"

    div ->
      "This element will NOT be redrawn: #{Math.random()}"

    div _on: 'visible', _template: (visible, data) ->
      if visible
        for item in data.items or []
          div -> item
}

