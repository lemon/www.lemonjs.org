
# dependencies
require '../components/examples/DataBinding'
require '../components/examples/DynamicFlowControl'
require '../components/examples/DynamicLists'
require '../components/examples/EventHandlers'
require '../components/examples/HelloWorld'
require '../components/examples/LemonUIExamples'
require '../components/examples/LifecycleHooks'
require '../components/examples/ModifyingData'
require '../components/examples/PageData'
require '../components/examples/References'
require '../components/examples/Routing'
require '../components/examples/StaticFlowControl'
require 'lemonjs-i8c/FastBrowsing'
require 'lemonjs-i8c/LaunchedRocket'
require 'lemonjs-i8c/OnlinePaintTool'
require 'lemonjs-i8c/Outline'
require 'lemonjs-i8c/Read'
require 'lemonjs-lui/Banner'
require 'lemonjs-lui/Button'
require 'lemonjs-lui/CodeBlock'

# helper
read = (component) ->
  fs = require 'fs'
  path = "#{__dirname}/../components/examples/#{component}.coffee"
  fs.readFileSync "#{path}", 'utf8'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'Index'
  id: 'index-page'

  data: {
    code: {
      'DataBinding': read 'DataBinding'
      'DynamicFlowControl': read 'DynamicFlowControl'
      'DynamicLists': read 'DynamicLists'
      'EventHandlers': read 'EventHandlers'
      'HelloWorld': read 'HelloWorld'
      'LemonUIExamples': read 'LemonUIExamples'
      'LifecycleHooks': read 'LifecycleHooks'
      'References': read 'References'
      'Routing': read 'Routing'
      'StaticFlowControl': read 'StaticFlowControl'
      'PageData': read 'PageData'
    }
  }

  lifecycle: {
    mounted: ->
      @goToExample()
  }

  methods: {
    goToExample: ->
      el = @el.querySelector "a[href$='example=#{page.query.example}']"
      lemon.scrollTo el if el
  }

  routes: {
    '*': 'goToExample'
  }

  template: (data) ->
    lui.Banner page.data.banner

    # features
    div '.section', ->
      div '.inner', ->
        for feature in page.data.features or []
          div ->
            div '.icon', ->
              i8[feature.icon] {size: 65}
            h2 -> feature.title
            p -> feature.description

    # examples
    for example in page.data.examples or []
      div '.section', ->
        div '.inner', ->
          if example.title
            h1 ->
              a href: "#{page.pathname}?example=#{example.component}", ->
                example.title
          if example.description
            p ->
              example.description
          div '.demo', ->
            div '.left', ->
              lui.CodeBlock {
                language: 'coffeescript'
                code: data.code[example.component]
              }
            div '.right', ->
              div class: {
                example: true
                custom: example.custom
              }, ->
                if site[example.component]
                  site[example.component]()
                else
                  console.warn "site.#{example.component} is not defined"

    if page.data.footer
      div '.section', ->
        div '.inner', ->
          for title in page.data.footer.title
            h1 -> title
          for paragraph in page.data.footer.text
            p -> paragraph
          div style: {margin: '0 auto', width: '50%'}, ->
            div '.half', ->
              h3 -> page.data.footer.red_pill
              div ->
                img src: '/img/red-pill.png'
              lui.Button {
                href: page.data.footer.lemon_href
                text: page.data.footer.choose_lemon
              }
            div '.half', ->
              h3 -> page.data.footer.blue_pill
              div ->
                img src: '/img/blue-pill.png'
              lui.Button {
                href: page.data.footer.react_href
                text: page.data.footer.choose_react
              }

}
