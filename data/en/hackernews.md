
This is the HackerNews demo for Lemon.js. If you're coming from Vue.js,
it will look very familiar to you.

# [Installation](/en/hackernews?q=installation)

```bash
# install lemon-cli globally with npm
> npm install -g lemonjs-cli
```

---

# [Create the project](/en/hackernews?q=create)

```bash
# create a directory for your new project
> mkdir -p ~/hackernews
> cd ~/hackernews

# create your new project from an existing lemon template
> lemon new hackernews
```

---

# [Project Structure](/en/hackernews?q=structure)

```bash
# quick glance at the project structure
> find .
.
./README.md           # project README
./data                # data files
./lemon.cson          # contains your lemon config file
./src                 # source code
./src/App.coffee      # main App
./src/components      # directory for components
./src/css             # directory for stylesheets
./src/index.coffee    # index.html template
./src/lib             # utility libraries
./src/static          # directory for static files
./src/views           # directory for routable views
```

---

# [Project Configuration](/en/hackernews?q=config)
### (lemon.cson)

```coffeescript
{
  name: "Lemon HackerNews Tutorial"
  prod: {
    hostname: 'hackernews.lemonjs.org'
  }
  dev: {
    port: 3000
  }
  deploy: {
    service: 'github'
  }
}
```

'prod.hostname' is the url your site will eventually be located at. This
property is available anywhere in your application as site.hostname. 'name' is
the name of your project. 'dev.port' is the port that your local development
server will use. "deploy.service" will be the service you plan to deploy
your app to.

---

# [index.html template](/en/hackernews?q=index)

lemon apps can have multiple root html template files, but a majority of
apps will just use a single one. We can set any properties we want, and
then load our site.App into the body.

```coffeescript
# dependencies
require './App'

# page template
module.exports = ->
  doctype 5
  html lang: 'en', ->
    head ->
      title -> 'HackerNews on lemon'
      meta charset: "utf-8"
      meta name: "mobile-web-app-capable", content: "yes"
      meta name: "apple-mobile-web-app-capable", content: "yes"
      meta name: "apple-mobile-web-app-status-bar-style", content: "default"
      link rel: "apple-touch-icon", sizes:"144x144", href: "/img/logo-144.png"
      meta name: "viewport", content:"width=device-width, initial-scale=1, minimal-ui"
      link rel: "shortcut icon", sizes: "64x64", href: "/img/icon-64.png"
      link rel: "manifest", href: "/manifest.json"
    body ->
      site.App()
```

---

# [App.coffee](/en/hackernews?q=app)

Here we load our libs, components, views, and stylesheets. We place
the header at the top, and then use a lemon.Router to control which
content to load based on the url.

We use beforeRoute to only re-render this content if the "action" changes.
The action is the function the route pattern is mapped to. For example, if
a user goes from a user page to an item page, the router will re-render.
However, if a user goes from /top to /new, the router does NOT re-render.
We leave it to the NewsView to decide what to do.

After routing, we scroll to the top of the page.

```coffeescript

# dependencies
require './components/Header'
require './lib/Api'
require './lib/Utils'
require './views/ItemView'
require './views/NewsView'
require './views/PageNotFoundView'
require './views/UserView'

# stylesheets
require './css/App.styl'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'App'
  id: 'app'

  lifecycle: {
    created: ->
      site.api = new site.Api()
      site.utils = new site.Utils()
  }

  template: (data) ->
    site.Header()
    lemon.Router {
      beforeRoute: (current, prev) ->
        return current.action isnt prev.action
      routes: {
        '/': -> lemon.route '/top'
        '/(top|new|show|ask|jobs):type/*page': site.NewsView
        '/user/:id': site.UserView
        '/item/:id': site.ItemView
        '/*': site.PageNotFoundView
      }
      routed: ->
        lemon.scrollTo document.body
    }
}
```

---

# [Components](/en/hackernews?q=components)

Notice that in the template, we use "site.Header()" to render the header at a
specific location. We use "site.UserView" (without calling the function) to set
a component to a route. In these common scenarios, we don't use the "new"
keyword. This will render a temporary dom element to the page. After render is
complete, the template is then hydrated. During hydration, this dom element
stub will be recognized, and a full component will be loaded and rendered into
it.

In our lifecycle hook, we do "new site.Api()" and "new site.Utils()". In this
case, we use the "new" keyword so that the component is immediately created and
returned, instead of a dom element. No dom was passed in, so this component
will not be attached to the DOM.

---

# [API](/en/hackernews?q=api)

Our API is similar to other components, except that we don't expect it
to be rendered to the dom. The data for our API contains the api root url
and a data cache. We use lemon.ajax to load the content from firebase.

```coffeescript
module.exports = lemon.Component {
  package: 'site'
  name: 'Api'

  data: {
    cache: {}
    root: 'https://hacker-news.firebaseio.com/v0'
  }

  methods: {

    fetch: (key, next) ->
      return setTimeout(( => next null, @cache[key]), 1) if @cache[key]
      lemon.ajax {
        method: 'GET'
        url: "#{@root}/#{key}.json"
      }, (err, data) =>
        @cache[key] = data
        next err, data

    fetchItem: (id, next) ->
      @fetch "item/#{id}", next

    fetchStories: (type, next) ->
      type = 'job' if type is 'jobs'
      @fetch "#{type}stories", next

    fetchUser: (id, next) ->
      @fetch "/user/#{id}", next

  }
}
```

---

# [A Simple View (UserView)](/en/hackernews?q=user-view)

Our UserView is quite simple (no dependencies).

First we define our data (state/props). We're going to load external
data, so we have a "loading" property. Then we track an "error" and "user"
property based on if we load our external data successfully.

We add a lifecycle hook to know when the component has been mounted, then
we use our "site.api" to fetch our data. When we get our response, we update
the error and user properties, then update loading to false.

In our template, we use binding on the "loading" property, so as soon as
we update "loading", that dom element and template will re-render and
re-hydrate. Then we decide whether to show an error or the user details.

```coffeescript

# stylesheets
require '../css/UserView.styl'

module.exports = lemon.Component {
  package: 'site'
  name: 'UserView'
  class: 'view'

  data: {
    loading: true
    error: null
    user: null
  }

  lifecycle: {
    mounted: ->
      site.api.fetchUser @params.id, (err, user) =>
        @error = err
        @user = user
        @loading = false
        setTimeout ( => lemon.addClass @el, 'loaded' ), 10
  }

  template: (data) ->
    div '.user-view', ->
      div _on: 'loading', _template: (loading, data) ->
        {error, user} = data
        if error
          div '.error', ->
            error
        else if user
          h1 -> "User: #{user.id}"
          ul '.meta', ->
            li ->
              span '.label', -> 'Created:'
              span '.value', -> site.utils.timeAgo user.created
            li ->
              span '.label', -> 'Karma:'
              span '.value', -> "#{user.karma}"
          div '.about', ->
            raw user.about
          div '.links', ->
            a href: "https://news.ycombinator.com/submitted?id=#{user.id}", ->
              'submissions'
            text " | "
            a hreF: "https://news.ycombinator.com/threads?id=#{user.id}", ->
              'comments'
}
```

---

# [A Complex View (NewsView)](/en/hackernews?q=news-view)

NewsView is a little more complex because it includes routing. NewsView depends
on a NewsItem component, so first we load that and our css. Our NewsView has
extra data to assist us with paging our application.

We add a route similar to what was in our site.App. This listens for changes
in the url so we can track which type of news we're trying to load and which
page should be loaded. When a route matches our pattern, the "onRoute" method
is called.

The params are nicely available in our "onRoute" method. We set "@loading" to
false and our dom re-renders. We load the data we need, update our state, then
set "@loading" to true and that part of the dom re-renders as well. We are
using binding twice on the "loading" property. Once within the navigation, and
the other for the content below. This allows us to not re-render the entire nav
element when updating.

```coffeescript

# dependencies
require '../components/NewsItem'

# stylesheets
require '../css/NewsView.styl'

module.exports = lemon.Component {
  package: 'site'
  name: 'NewsView'
  class: 'view'

  data: {
    error: null
    ids: []
    loading: true
    num_pages: 1
    page: 1
    page_size: 20
    type: null
  }

  methods: {

    onRoute: ({params}) ->
      page = parseInt(params.page) or 1
      type = params.type or 'new'
      start = @page_size * (page-1)
      end = @page_size * page
      @loading = true
      site.api.fetchStories type, (err, ids) =>
        @error = err
        @ids = ids[start...end]
        @page = page
        @type = type
        @num_pages = Math.ceil ids.length / @page_size
        @loading = false
        setTimeout ( => lemon.addClass @el, 'loaded' ), 10
  }

  routes: {
    '/(top|new|show|ask|jobs):type/*page': 'onRoute'
  }

  template: ->
    div '.view-nav', ->
      span _on: 'loading', _template: (loading, data) ->
        a {
          class: {disabled: data.page is 1}
          href: "/#{data.type}/#{data.page - 1}"
        }, ->
          '< prev'
        span ->
          text "#{data.page}/"
          text "#{data.num_pages}"
        a {
          class: {disabled: data.page is data.num_pages}
          href: "/#{data.type}/#{data.page + 1}"
        }, ->
          'more >'

    div '.news-list', _on: 'loading', _template: (loading, data) ->
      {error, ids} = data
      if error
        div '.error', ->
          error
      else if ids
        for id in ids
          site.NewsItem {item_id: id}
  }
```

---

# [Styling](/en/hackernews?q=styling)

You probably noticed we're been requiring stylus files. Lemon supports css
and stylus by default. Lemon will hot-reload our page when these files change
and will compile and bundle them together for us when we build our app. I'll
assume you know css and we don't need to go through the source code.

---

# [Run the Development Server](/en/hackernews?q=dev)

```bash
> lemon dev
listening at http://localhost:3000
```

---

# [That's it!](/en/hackernews?q=done)

That's all! This app was built with lemon build and then deployed to github
pages using lemon deploy. Note that because this a static hosted version, it
can only provide server-side rendering for the primary pages (/top, /new, etc.)
because we can't know which item ids and user ids will exist in the future.

A next step would be to create a simple local server, listen for the desired
routes, load data from firebase in the request handler, and then call
lemon.compile to render our html server-side with dynamically loaded data.

We'll save that for another day though.

https://hackernews.lemonjs.org
