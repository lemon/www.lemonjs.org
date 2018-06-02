
# dependencies
require 'lemonjs-lui/Header'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'Header'
  id: 'header'

  template: (data, contents) ->
    lang = page.pathname[1...3]
    return if lang is data.lang

    lui.Header {
      logo: 'lemon'
      nav: site.data["/#{lang or 'en'}/nav"]?.links or []
    }
    data.lang = lang
    return
}
