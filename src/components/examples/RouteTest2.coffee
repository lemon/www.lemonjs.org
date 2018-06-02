
module.exports = lemon.Component {
  package: 'site'
  name: 'RouteTest2'

  template: (data) ->
    div ->
      'This is site.RouteTest2 component'
    div ->
      "(2) location.pathname: #{location.pathname}"
}

