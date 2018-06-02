
这是Lemon.js的HackerNews演示。 如果你知道Vue.js，它会看起来非常熟悉。

# [安装](/zh/hackernews?q=installation)

```bash
# 用npm在全球范围内安装lemon-cli
> npm install -g lemonjs-cli
```

---

# [创建一个项目](/zh/hackernews?q=create)

```bash
# 为您的新项目创建一个目录
> mkdir -p ~/hackernews
> cd ~/hackernews

# 从现有的Lemon.js模板创建您的新项目
> lemon new hackernews
```

---

# [项目结构](/zh/hackernews?q=structure)

```bash
# 简要概述项目结构
> find .
.
./README.md           # 项目自述文件
./data                # 应用数据
./lemon.cson          # 包含您的Lemon.js配置
./src                 # 源代码目录
./src/App.coffee      # 你的应用
./src/components      # 浏览器组件
./src/css             # 样式表
./src/index.coffee    # 索引页面
./src/lib             # 实用程序库
./src/static          # 静态文件
./src/views           # 应用视图
```

---

# [项目配置](/zh/hackernews?q=config)
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

"prod.hostname"是您的网站最终将位于的网址。
此属性在应用程序中的任何地方都可用作"site.hostname"。 "name"是您的项目的名称。
"dev.port"是您的本地开发服务器将使用的端口。

---

# [索引页面](/zh/hackernews?q=index)

Lemon.js应用程序可以有多个HTML模板文件，但大多数应用程序只能使用一个。
我们可以设置我们想要的任何属性，然后将site.App加载到body中。

```coffeescript
# 软件依赖关系
require './App'

# 模板
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

# [你的应用](/zh/hackernews?q=app)

现在我们加载我们的库，浏览器组件，视图和样式表。
我们将头部放在顶部，然后使用lemon.Router来控制要加载的内容。

如果“action”更改，我们会使用beforeRoute来仅重新呈现此内容。
该动作是路由模式映射到的功能。
例如，如果用户从用户页面转到项目页面，路由器将重新渲染。 但是，如果用户从"/top"
到"/new"，则路由器不会重新渲染。 我们把它留给NewsView来决定做什么。

路由后，我们滚动到页面顶部。

```coffeescript
# 软件依赖关系
require './components/Header'
require './lib/Api'
require './lib/Utils'
require './views/ItemView'
require './views/NewsView'
require './views/PageNotFoundView'
require './views/UserView'

# 样式表
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

# [Components](/zh/hackernews?q=components)

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

# [API](/zh/hackernews?q=api)

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

# [A Simple View (UserView)](/zh/hackernews?q=user-view)

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

# 样式表
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

# [A Complex View (NewsView)](/zh/hackernews?q=news-view)

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

# 软件依赖关系
require '../components/NewsItem'

# 样式表
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

# [Styling](/zh/hackernews?q=styling)

You probably noticed we're been requiring stylus files. Lemon supports css
and stylus by default. Lemon will hot-reload our page when these files change
and will compile and bundle them together for us when we build our app. I'll
assume you know css and we don't need to go through the source code.

---

# [Run the Development Server](/zh/hackernews?q=dev)

```bash
> lemon dev
listening at http://localhost:3000
```

---

# [That's it!](/zh/hackernews?q=done)

That's all! This app was built with lemon build and then deployed to github
pages using lemon deploy. Note that because this a static hosted version, it
can only provide server-side rendering for the primary pages (/top, /new, etc.)
because we can't know which item ids and user ids will exist in the future.

A next step would be to create a simple local server, listen for the desired
routes, load data from firebase in the request handler, and then call
lemon.compile to render our html server-side with dynamically loaded data.

We'll save that for another day though.

https://hackernews.lemonjs.org
