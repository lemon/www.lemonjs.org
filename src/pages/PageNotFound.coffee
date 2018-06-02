
# dependencies
require 'lemonjs-i8c/Books'
require 'lemonjs-i8c/Clock'
require 'lemonjs-i8c/Communication'
require 'lemonjs-i8c/Cottage'
require 'lemonjs-i8c/Info'
require 'lemonjs-i8c/News'
require 'lemonjs-i8c/SourceCode'
require 'lemonjs-lui/Banner'
require 'lemonjs-lui/Button'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'PageNotFound'
  id: 'page-not-found'

  lifecycle: {
    beforeRoute: (pathname, {params}) ->
      @data = site.data["/#{params.lang or 'en'}/page-not-found"]
  }

  routes: {
    '*': ->
  }

  template: (data, contents) ->
    if data.banner
      lui.Banner data.banner

    if data.message
      h2 style: 'margin: 0 auto;padding-top:20px;', ->
        data.message

    if data.grid
      div '.grid', style: {padding: '40px'}, ->
        for pkg in data.grid
          div '.grid-item', ->
            a '.inner', href: pkg.href, ->
              span ->
                i8[pkg.icon] {class: 'icon', size: 65}
                span -> pkg.name
}
