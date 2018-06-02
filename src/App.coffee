
# dependencies
require './pages/Api'
require './pages/PageNotFound'
require './pages/HowTo'
require './components/Footer'
require './components/Header'
require './pages/Index'
require './pages/Examples'
require './pages/ClockTutorial'
require './pages/HackerNewsTutorial'

# stylesheets
require './css/App.styl'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'App'
  id: 'app'

  template: (data) ->
    site.Header()
    lemon.Router {
      beforeRoute: ({pathname, query}, prev) ->
        return false if pathname is prev.pathname

        if pathname is '/'
          return lemon.route '/en'
        if query['item'] in ['1', '2', '3']
          return false if @_mounted
        if query['example']
          return false if @_mounted
        if pathname.indexOf('/route-test') > -1
          if not @_mounted
            lang = pathname.match(/(.*)\/route-test/)?[1] or '/en'
            lemon.route lang
          return false
        return true
      routes: {
        '/': -> lemon.route '/en'
        '/(en|zh)': site.Index
        '/(en|zh)/api': site.Api
        '/(en|zh)/how-to': site.HowTo
        '/(en|zh)/examples': site.Examples
        '/(en|zh)/clock': site.ClockTutorial
        '/(en|zh)/hackernews': site.HackerNewsTutorial
        '/(en|zh)/route-test*': site.Index
        '/(en|zh):lang/*': site.PageNotFound
        '/*': site.PageNotFound
      }
      routed: ->
        lemon.scrollTo document.body

    }
    site.Footer()

}
