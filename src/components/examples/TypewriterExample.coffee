
# dependencies
lui.Typewriter = require 'lemonjs-lui/Typewriter'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'TypewriterExample'

  lifecycle: {
    mounted: ->
      @$typewriter.start()
  }

  methods: {
    goToNext: ->
      if @$typewriter.is_complete
        @$typewriter.goto 0
      else
        @$typewriter.next()
  }

  template: ->
    div style: {
      border: '1px solid black'
      padding: '20px'
      'font-size': '18px'
      'text-align': 'center'
    }, ->
      lui.Typewriter {
        ref: '$typewriter'
        text: [
          'hello world'
          'how are you today?'
          "i'm good too. Thanks for asking."
        ]
      }
      lui.Button {
        text: 'next'
        $click: 'goToNext'
      }
}
