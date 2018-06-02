# dependencies
require 'lemonjs-i8c/Cauliflower'
require 'lemonjs-i8c/Citrus'
require 'lemonjs-i8c/DropShipping'
require 'lemonjs-i8c/FiremanBoots'
require 'lemonjs-i8c/News'
require 'lemonjs-i8c/Octahedron'
require 'lemonjs-i8c/Read'
require 'lemonjs-i8c/Sunset'
require 'lemonjs-i8c/WebDesign'
require 'lemonjs-i8c/Youtube'
require 'lemonjs-lui/Banner'
require 'lemonjs-lui/Grid'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'Examples'
  id: 'examples-page'

  data: {
    banner: {
      title: 'Examples'
      subtitle: 'Below are some examples of lemon in action'
    }
    sites: [
      {href: 'https://www.lemonjs.org', name: 'Lemon', icon: 'Citrus'}
      {href: 'https://www.introtochinese.com', name: 'Intro to Chinese', icon: 'Read'}
      {href: 'https://youtube.lemonjs.org', name: 'Youtube Clone', icon: 'Youtube'}
      {href: 'https://hackernews.lemonjs.org', name: 'Hackernews Clone', icon: 'News'}
    ]
    libs: [
      {href: 'https://bs.lemonjs.org', name: 'Bootstrap', icon: 'FiremanBoots'}
      {href: 'https://cd.lemonjs.org', name: 'Codrops', icon: 'DropShipping'}
      {href: 'https://i8c.lemonjs.org', name: 'Icons8 (Cotton)', icon: 'Cauliflower'}
      {href: 'https://i8u.lemonjs.org', name: 'Icons8 (UV)', icon: 'Sunset'}
      {href: 'https://lui.lemonjs.org', name: 'Lemon UI', icon: 'Citrus'}
      {href: 'https://mui.lemonjs.org', name: 'Material', icon: 'WebDesign'}
    ]
  }

  template: (data) ->
    lui.Banner data.banner

    h2 -> 'Sites'
    lui.Grid {
      items: data.sites
    }
    hr()

    h2 -> 'Component Libraries'
    lui.Grid {
      items: data.libs
    }
    hr()
}
