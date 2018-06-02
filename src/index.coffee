
# dependencies
require './App'

# page template
module.exports = ->
  doctype 5
  html lang: 'en', ->
    head ->
      title 'lemon.js'
    body ->
      site.App()
