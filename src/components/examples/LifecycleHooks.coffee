module.exports = lemon.Component {
  package: 'site'
  name: 'LifecycleHooks'

  data: {
    events: []
  }

  lifecycle: {
    beforeCreate: ->  # @events not available yet
    created: ->   @events.push 'created'
    beforeMount: ->  @events.push 'beforeMount'
    mounted: ->   @events.push 'mounted'
    beforeDestroy: -> @events.push 'beforeDestroy'
    destroyed: ->  @events.push 'destroyed'
  }

  template: (data) ->

    div _list: 'events', _template: (event) ->
      span -> event

    button $click: '_destroy', ->
      'Click to destroy this component'
}
