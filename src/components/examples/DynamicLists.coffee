module.exports = lemon.Component {
  package: 'site'
  name: 'DynamicLists'

  data: {
    counter: 0
    items: []
  }

  methods: {
    onPush: ->    @items.push(++@counter)
    onPop: ->     @items.pop()
    onShift: ->   @items.shift()
    onUnshift: -> @items.unshift(++@counter)
    onReset: ->   @items = []
    onReverse: -> @items.reverse()
    onSort: ->    @items.sort()
  }

  template: (data) ->

    for action in ['Push', 'Pop', 'Unshift', 'Shift', 'Reset', 'Reverse', 'Sort']
      button $click: "on#{action}", ->
        action

    div _list: 'items', _template: (item) ->
      span ->
        "#{item}"
}

