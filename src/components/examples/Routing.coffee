
# dependencies
require './RouteTest1'
require './RouteTest2'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'Routing'

  template: (data) ->
    div ->
      a href: "#{location.pathname}/route-test-1", -> 'route-1'
      a href: "#{location.pathname}/route-test-2", -> 'route-2'
      a href: "#{location.pathname}/route-test-3", -> 'route-3'
    lemon.Router {
      '/:lang/route-test-1': site.RouteTest1
      '/:lang/route-test-2': site.RouteTest2
      '/:lang/route-test-3': -> div -> 'hello world'
    }

}

