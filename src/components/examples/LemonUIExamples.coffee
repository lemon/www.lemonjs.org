
# dependencies
require 'lemonjs-lui/Button'
require 'lemonjs-lui/HeaderMenu'
require 'lemonjs-lui/Input'

# Component
module.exports = lemon.Component {
  package: 'site'
  name: 'LemonUIExamples'

  template: (data) ->

    lui.HeaderMenu {
      items: [
        {href: "#{page.pathname}?item=1", text: 'Item 1'}
        {href: "#{page.pathname}?item=2", text: 'Item 2'}
        {href: "#{page.pathname}?item=3", text: 'Item 3'}
      ]
    }

    lui.Button {color: 'purple', text: 'Click Here'}

    lui.Input {label: 'type here'}

}
