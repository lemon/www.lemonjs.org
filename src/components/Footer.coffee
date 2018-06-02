
# stylesheets
lui.Footer = require 'lemonjs-lui/Footer'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'Footer'
  id: 'footer'

  template: ->
    lui.Footer {}, ->
      div ->
        'Released under the MIT License'
      div ->
        'Copyright © 2018 Shenzhen239'

      div ->
        a href: 'https://icons8.com', ->
          'Icon pack by Icons8'
      div style: 'display: none', ->
        a href: '/zh', ->
          img src: 'https://png.icons8.com/office/40/000000/china.png'
        a href: '/fr', ->
          img src: 'https://png.icons8.com/office/40/000000/france.png'
        a href: '/en', ->
          img src: 'https://png.icons8.com/office/40/000000/usa.png'
}
