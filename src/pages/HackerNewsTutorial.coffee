
# dependencies
require 'lemonjs-lui/Banner'
require 'lemonjs-lui/Story'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'HackerNewsTutorial'

  template: ->
    lui.Banner page.data.banner
    lui.Story {
      nav: page.data.nav
      markdown: page.markdown
    }

}
