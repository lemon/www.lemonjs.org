module.exports = lemon.Component {
  package: 'site'
  name: 'StaticFlowControl'

  data: {
    items: ['a', 'b']
    visible: true
  }

  methods: {
    update: ->
      @visible = not @visible
      @mount()
  }

  template: (data) ->
    {items, visible} = data

    button $click: 'update', ->
      "Click to toggle visible"

    div ->
      "This element will be redrawn: #{Math.random()}"

    if visible
      for item in items
        div -> item

}

