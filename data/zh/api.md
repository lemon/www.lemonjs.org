
# [Components](/en/api?q=components)

```coffeescript
module.exports = lemon.Component {



  # [package](/en/api?q=components.package)
  # _
  # This namespace will be used anytime your component is used
  # defaults to "window", but it is strongly encouraged to
  # choose a unique namespace.
  package: 'my-package'



  # [name](/en/api?q=components.name)
  # _
  # This is the name of your component. It identifies the name
  # that must be used when people use your component. Keep it
  # short, but descriptive.
  name: 'MyComponent'



  # [id](/en/api?q=components.id)
  # _
  # This option will set an id property on every instance of
  # your component. This is commonly used to idenfity pages
  # in your site and not often used for 3rd-party components.
  id: 'element-id'



  # [class](/en/api?q=components.class)
  # _
  # This option will set a class property on every instance of
  # your component. It's common to set a class name on re-useable
  # components so that you can style them.
  class: 'element-class'



  # [data](/en/api?q=components.data)
  # _
  # Data will define the default values for your data object
  # on a component instance. Anything here can be overridden
  # when a user instantiates a component. Data attributes are
  # available in your component template, as well as in any
  # methods on your component.
  # _
  # Each data property will be made available directly on the
  # component instance. In this example, "foo" would be able
  # to be referenced as @foo in your listeners and methods. It
  # could be updated with `@foo = "new bar"`.
  data: {
    foo: "bar"
    items: [1, 2, 3]
    more_items: [
      {a: '1'}
      {b: '2'}
    ]
    date: new Date()
  }



  # [computed](/en/api?q=components.computed)
  # _
  # Computed allows you to define computed properties to avoid
  # putting this logic in your templates. Computed properties
  # can be used within methods and within templates
  computed: {
    prettyDate: ->
      @date.toLocaleTimeString()
  }



  # [watch](/en/api?q=components.watch)
  # _
  # Most of the time you will use template binding to modify
  # your component when data properties change, but sometimes
  # you want to take a specific action when data changes. Watch
  # allows you to execute custom functions when your data
  # properties are modified.
  watch: {
    date: (new_date) ->
      console.log 'date has changed!'
  }



  # [lifecycle](/en/api?q=components.lifecycle)
  # _
  # Lifecycle methods allow you to take action at certain
  # stages of your components life. The most commonly used
  # is "mounted" which will be called after your template
  # has been mounted and inserted into the dom.
  # _
  # In other frameworks, using "beforeDestroy" or "componentDidUnmount"
  # lifecycle hooks are common. In lemon, you typically don't need to
  # do that. All child component references are internally maintained.
  lifecycle: {
    beforeCreate: ->
    created: ->
    beforeMount: ->
    mounted: ->
    beforeDestroy: ->
    destroyed: ->
    beforeRoute: (pathname, options) ->
    routed: (pathname, options) ->
  }



  # [methods](/en/api?q=components.methods)
  # _
  # Methods is where you can define any actions you want your
  # component to be able to take. This will typically involve
  # handling events, making API calls, and other interactive
  # features.
  # _
  # Similar to "data" properties, these methods will be exposed
  # directly on the component instance.
  methods: {
    printHello: ->
      console.log 'hello'
  }



  # [routes](/en/api?q=components.routes)
  # _
  # Routes allows you to add listeners and take action when 
  # the url of the app changes.
  # _
  # you can also use lemon.Router directly in templates, this
  # will be show below in the templates section
  routes: {
    '/': 'onIndexPageLoad'
    '/api*': 'onApiPageLoad'
    '/inline-action': -> console.log 'inline action route'
  }



  # [template](/en/api?q=components.template)
  # _
  # Template is the most import property of a component. It
  # defines what will mount into the dom. Almost all standard
  # dom tags are readily available, as well as loaded Components.
  # _
  # See below for more thorough details about what you can do with
  # templates.
  template: (data, contents) ->
    label -> data.foo
    div '.my-contents', ->
      contents()

}
```

---

# [Templates](/en/api?q=templates)

```coffeescript

module.exports = lemon.Component {

  template: (data, contents) ->



    # [tags](/en/api?q=templates.tags)
    # _
    # Tags are the regular dom elements that you already know about.
    # If you find a tag that isn't support, use "tag {element_name}"
    div ->
      'text'
    span ->
      'text'
    hr()
    br()
    tag 'svg', ->



    # [attributes](/en/api?q=templates.attributes)
    # _
    # Attributes are set by passing an object into the tag function
    a href: '', alt: '', ->
      'link'
    a {href: '', alt: ''}, ->
      'link'



    # [contents](/en/api?q=templates.contents)
    # _
    # Contents of a tag get passed as a function.
    # Here we draw the contents passed to this template.
    div ->
      contents()

    # Here we are passing contents to a child component
    pkg.SomeComponent {}, ->
      'Here we are defining contents to pass to our component'



    # [id](/en/api?q=templates.id)
    # _
    # How to set the id attribute on a dom element. You can use
    # '#' in a string as the first argument to the tag element
    # for shorthand syntax.
    div {id: 'my-div-1'}, ->
    div id: 'my-div-2'}, ->
    div '#my-div-3', ->



    # [class](/en/api?q=templates.class)
    # _
    # How to set the class attribute on a dom element. You can use
    # '.' in a string as the first argument to the tag element
    # for shorthand syntax. If you pass an object as the value
    # to class, it will include the classes for which the value
    # is truthy.
    div {class: 'my-div-1'}, ->
    div class: 'my-div-2', ->
    div '.my-div-3', ->
    div class: {
      button: true
      filled: data.is_filled
    }



    # [style](/en/api?q=templates.style)
    # _
    # How to set inline css styles on a dom element
    div {style: 'color: red'}, ->
    div style: 'color:red', ->
    div style: {
      background: data.background
      color: data.color
    }



    # [raw](/en/api?q=templates.raw)
    # _
    # If you need to input html directly, use "raw"
    div ->
      raw data.html_value



    # [text](/en/api?q=templates.text)
    # _
    # If you need to input text without an element, use "text"
    div ->
      span -> 'item 1'
      text ", "
      span -> "item 2"



    # [event handling](/en/api?q=templates.events)
    # _
    # To handle events, use the "on" property or the "$" shorthand
    div on: {
      click: 'onClick'
      mouseover: 'onMouseover'
      mouseout: 'onMouseOut'
    }, ->
      'hello world'

    div $click: 'onClick', ->
      'hello world'



    # [data binding](/en/api?q=templates.binding)
    # _
    # To have templates automatically update as data changes,
    # use data binding. "href", "src", "text", and "html" will
    # perform specific updates to your elements. The "on" binding
    # will allow you to redraw any piece of your dom when that
    # value changes.
    a bind: {href: 'url'}, -> 'link'
    img bind: {src: 'url'}
    span bind: {text: 'text_property'}

    a _href: 'url', -> 'link'
    img _src: 'url'
    span _text: 'text_property'

    div _on: 'some_property', _template: (value) ->
      span -> value



    # [binding lists](/en/api?q=templates.binding-lists)
    # _
    # Use _list to bind a list. When binding a list you must provide
    # either a template to draw, or a component to mount.
    ul _list: 'my_list', _template: (item) ->
      li ->
        item.text

    ul _list: 'my_list', _component: pkg.SomeComponent



    # [refs](/en/api?q=templates.refs)
    # _
    # Use "ref" to make a component or element easier to access in
    # your component methods. When assigning a ref, you'll be able
    # to access that element or component at "@myref". It is good
    # practice to start ref names with a "$" to distinguish them
    # from methods and data.
    div ->
      pkg.SomeComponent {ref: '$some_component'}
      span ref: '$some_span'



    # [router](/en/api?q=templates.router)
    # _
    # Use "lemon.Router" to allow multiple different components to
    # load conditioned upon the current url.
    div ->
      lemon.Router {
        '/api': site.ApiPage
        '/faq': site.FaqPage
        '/hello': ->
          div -> 'hello world'
      }


}
```

---

# [lemon.Router](/en/api?q=lemon.Router)

```coffeescript

module.exports = lemon.Component {

  template: (data, contents) ->

    # [basics](/en/api?q=lemon.Router/basics)
    # _
    # Use a lemon.Router to react to page changes
    lemon.Router {
      '/': -> console.log 'index page'
      '/:lang/api': -> console.log 'api page'
      '/:lang/how-to': -> console.log 'how-to page'
    }



    # [components](/en/api?q=lemon.Router/components)
    # _
    # The most common use of a lemon.Router is to control
    # which page will be loaded for your app. Simply use
    # the component as the action for each route.
    # Note that any of the component routed to could have
    # their own lemon.Routers inside them. This allows for very
    # clean routing definition.
    lemon.Router {
      '/': -> site.IndexPage
      '/api': -> site.ApiPage
      '/how-to': -> site.HowToPage
      '/tutorials/*': -> site.TutorialWrapperPage
    }





    # [beforeRoute](/en/api?q=lemon.Router/beforeRoute)
    # _
    # There's a hook to take action prior to performing the route.
    # If your beforeRoute method returns false (boolean), then the
    # Router will not update. The default behavior is to only route
    # when location.pathname changes. You could override this behavior
    # to reload everytime a query parameter is modified. 
    lemon.Router {
      beforeRoute: ((current, prev) ->
        if current.pathname is prev.pathname
          if current.search is prev.search
            return false
        return true
      )
      routes: {
        '/': -> console.log 'index page'
        '/:lang/api': -> console.log 'api page'
        '/:lang/how-to': -> console.log 'how-to page'
      }
    }



    # [routed](/en/api?q=lemon.Router/routed)
    # _
    # There's a hook to take action after performing the route.
    lemon.Router {
      routes: {
        '/': -> console.log 'index page'
        '/:lang/api': -> console.log 'api page'
        '/:lang/how-to': -> console.log 'how-to page'
      }
      routed: ((current, previous) ->
        console.log 'done routing. scroll to top of page'
        lemon.scrollTo document.body
      )
    }



    # [patterns](/en/api?q=lemon.Router/patterns)
    # _
    # lemon.Router handles route patterns similar to most other
    # libraries. Below are examples of routing patterns.
    lemon.Router {

      # direct match
      '/': ->
      '/en/api': ->

      # named parameters
      '/:lang/api': ->
      '/video/:id': ->

      # expression parameters
      '/(en|zh)/api': ->
      '/video/([0-9]+)': ->

      # named expression parameters
      '/(en|zh):lang/api': ->
      '/video/([0-9]+):id': ->

      # splat parameters (matches everything, including /)
      '/en/*': ->
      '/*': ->

      # named splat parameters
      '/en/*foo': ->

    }


```

---

# [lemon](/en/api?q=lemon)

```coffeescript


# [lemon.addClass](/en/api?q=lemon.addClass)
# _
# Function for adding a class to a dom element
> var el = document.getElementById('app');
> lemon.addClass(el, 'test-class');
> el.getAttribute('class');
"test-class"



# [lemon.browser_events](/en/api?q=lemon.browser_events)
# _
# List of browser methods available in the current browser
# for adding event listeners on
> lemon.browser_events
(85) ["click", "focus", "mouseover", "contextmenu", "copy", "scroll", ...]



# [lemon.checkRoute](/en/api?q=lemon.checkRoute)
# _
# Function to check whether a routing pattern matches
# the current url of the page
#
# The result contains the page details: hash, href, params, pathname, query
> lemon.checkRoute("/:lang/api");
{
  hash: "",
  href: "http%3A//localhost:3000/en/api",
  params: {},
  pathname:"/en/api",
  query: {"": undefined}
}


# [lemon.checkRoutes](/en/api?q=lemon.checkRoutes)
# _
# Function to check a given set of routes and return
# the first one that matches the current url, if any.
#
# The result contains the page details: hash, href, params, pathname, query
# As well as the pattern of the route that was matched, and the action to take
> lemon.checkRoutes({
  '/': function(){},
  '/:lang': function(){},
  '/:lang/api': function(){}
})
{
  action: f(),
  hash: "",
  href: "http%3A//localhost:3000/en/api",
  params: {lang: "en"}
  pathname:"/en/api",
  pattern: "/:lang/api",
  query: {}
}



# [lemon.copy](/en/api?q=lemon.copy)
# _
# Function to deep copy an object
> var item = {hello: "world", obj: {key: "value"}};
> var copy = lemon.copy(item);
> item.obj === copy.obj
false
> item.obj.key === copy.obj.key
true



# [lemon.get](/en/api?q=lemon.get)
# _
# Function to get a component instance by unique id
# lemon.get(id) is equivalent to lemon.Components[id]
# components will be given non-identifiable unique ids
# unless a specific id is given to the component
> lemon.get('app').id
app



# [lemon.hasClass](/en/api?q=lemon.hasClass)
# _
# Function for checking if an element has a class
> var el = document.getElementById('app');
> lemon.hasClass(el, 'test-class');
true



# [lemon.loadElement](/en/api?q=lemon.loadElement)
# _
# Function to load a component from a dom element
# Any dom element containing the lemon-component attribute
# can be used. This function will load the component spec
# then create the component using lemon-data and lemon-contents
# as input parameters.
> var el, target;
> el = document.createElement('div')
> el.innerHTML = "<div id='test-clock' lemon-component='site.Clock'></div>"
> document.body.appendChild(el)
> target = document.getElementById('test-clock')
> lemon.loadElement(target)
> // scroll down to the bottom of the page



# [lemon.offset](/en/api?q=lemon.offset)
# _
# Function to find a dom elements location in the browser/window
# Includes standard getBoundingClientRect() properties, as well
# as _top and _bottom which specify the elements distance to the
# top and bottom of the current viewport.



# [lemon.removeClass](/en/api?q=lemon.removeClass)
# _
# Function for removing a class to a dom element
> var el = document.getElementById('app');
> lemon.removeClass(el, 'test-class');
> el.getAttribute('class');
""




# [lemon.route](/en/api?q=lemon.route)
# _
# Function for programmatic page changes. Relative links
# will be intercepted and change page locally, but sometimes
# you want to force a page change programmatically. Simply
# call lemon.route(url)
> lemon.route(location.pathname + '?q=lemon.route')
> // url updates and this page scrolls to this paragraph



# [lemon.scrollTo](/en/api?q=lemon.scrollTo)
# _
# Function for scrolling the window to a specific element.
> lemon.route(location.pathname + '?q=lemon.route')
> // url updates and this page scrolls to this paragraph


```

---

# [Global Events](/en/api?q=lemon.events)

```coffeescript


# [lemon.once](/en/api?q=lemon.once)
# _
# Function to add a one-time listener for a global event
#
> lemon.once("scroll", function(e){console.log(e)});
> // scroll your page
Event {isTrusted: true, type: "scroll", target: document, ...}



# [lemon.on](/en/api?q=lemon.on)
# _
# Function to add a listener for a global event
#
> var fn = function(e) {console.log(e)}
> lemon.on("scroll", fn);
> // scroll your page
Event {isTrusted: true, type: "scroll", target: document, ...}
Event {isTrusted: true, type: "scroll", target: document, ...}
Event {isTrusted: true, type: "scroll", target: document, ...}
...



# [lemon.off](/en/api?q=lemon.off)
# _
# Function to remove a listener for a global event
> lemon.off("scroll", fn);
> // scroll your page



# [lemon.emit](/en/api?q=lemon.emit)
# _
# Function to emit a global event
> lemon.emit("user-logged-in");



# [lemon.on('scroll')](/en/api?q=lemon.on/scroll)
# _
# A listener for window scrolling is available for listening to.
> lemon.on("scroll", function(e){});



# [lemon.on('resize')](/en/api?q=lemon.on/resize)
# _
# A listener for window resizing is available for listening to.
> lemon.on("resize", function(e){});



# [lemon.on('url_change')](/en/api?q=lemon.on/url_change)
# _
# Listener for history pushState/replaceState and window popstate
> lemon.on("url_change", function(e){});


```

# [Lemoncup](/en/api?q=lemoncup)

```coffeescript


# [lemoncup.render](/en/api?q=lemoncup.render)
# _
# Function for rendering a template. Supports basic
# coffeescript templating, as well as lemon special features
# for classes, styles, data binding, and event handling
> var template = function(){
    div('.button', function(){
      text('click me')
    })
  }
> lemoncup.render(template)
"<div class=".button">click me</div>"

> var template = function(){
    div({$click: function(){
      console.log('on click')}
    }, function(){
      text('click me')
    })
  }
> lemoncup.render(template)
"<div lemon-on:click="59">click me</div>"

> lemoncup._data[59]
ƒ (){ console.log('on click') }



```

---

# Still have questions?

Visit our [How To](/en/how-to) for code samples of common questions.

