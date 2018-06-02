module.exports = lemon.Component {
  package: 'site'
  name: 'EventHandlers'

  data: {
    output: '[event data will show up here]'
  }

  methods: {
    handleEvent: (event) ->
      @output = "[#{event.type}] on #{event.target.innerText}"
  }

  template: (data) ->

    # "on" property (nice when you need lots of handlers)
    button on: {
      mouseover: "handleEvent"
      mouseout: "handleEvent"
      click: "handleEvent"
    }, ->
      "Mouseover Me"

    # "$" shorthand (convenient when you need one handler)
    button $click: 'handleEvent', ->
      "Click Me"

    # div for test output
    div _text: 'output'

}
