
# styling
require '../css/Clock.css'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'Clock'
  id: 'clock-demo'

  data: {
    time: Date.now()
  }

  lifecycle: {
    mounted: ->
      @interval_id = setInterval ( =>
        @time = Date.now()
      ), 1000

    beforeDestroy: ->
      clearInterval @interval_id
  }

  template: (data) ->
    div _on: 'time', _template: (time) ->
      new Date(time).toLocaleTimeString()

}

