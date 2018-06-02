module.exports = lemon.Component {
  package: 'site'
  name: 'ModifyingData'

  data: {
    static: 'static string'
    dynamic: 'dynamic string'
    counter: 1
  }

  methods: {
    update: ->
      @counter++
      @static = "static string: #{@counter}"
      @dynamic = "dynamic string: #{@counter}"
  }

  template: (data) ->

    button $click: 'update', ->
      "Click to increase counter"

    button $click: 'mount', ->
      "Click to re-mount the component"

    div _text: 'dynamic'

    div ->
      data.static

}

