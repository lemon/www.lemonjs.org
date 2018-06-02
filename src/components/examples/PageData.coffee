module.exports = lemon.Component {
  package: 'site'
  name: 'PageData'

  template: ->
    div -> "url: #{page.url}"
    div -> "page title: #{page.data.banner.title}"
    div -> "# examples: #{page.data.examples.length}"

}
