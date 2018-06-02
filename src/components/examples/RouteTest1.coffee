
module.exports = lemon.Component {
  package: 'site'
  name: 'RouteTest1'

  template: (data) ->
    div ->
      'This is site.RouteTest1 component'
    div ->
      "(1) location.pathname: #{location.pathname}"
}

