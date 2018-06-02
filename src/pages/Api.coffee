
# dependencies
require 'lemonjs-lui/Banner'
require 'lemonjs-lui/Story'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'Api'

  template: ->
    lui.Banner page.data.banner
    lui.Story {
      autonav: true
      nav: page.data.nav
      markdown: page.markdown
      exclude: page.data.exclude
    }
}
