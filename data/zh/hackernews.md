
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

# 浏览器组件
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

# [浏览器组件](/zh/hackernews?q=components)

请注意，在模板中，我们使用“site.Header（）”在特定位置呈现标题。
我们使用“site.UserView”（不调用该函数）将组件设置为路径。
在这些常见的情况下，我们不使用“新”关键字。 这会在页面上呈现一个临时的DOM元素。
渲染完成后，模板将被水化。
在水化过程中，这个DOM元素存根将被识别，并且一个完整的组件将被加载并渲染到其中。

在我们的生命周期挂钩中，我们执行“new site.Api（）”和“new site.Utils（）”。
在这种情况下，我们使用“new”关键字，以便立即创建并返回组件，而不是DOM元素。
没有dom被传入，所以这个组件不会被连接到DOM。

---

# [应用程式介面](/zh/hackernews?q=api)

我们的API与其他组件类似，不同之处在于我们不期望将其呈现给DOM。
我们的API的数据包含api根URL和数据缓存。 我们使用lemon.ajax从Firebase加载内容。

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

# [用户页面](/zh/hackernews?q=user-view)

我们的UserView非常简单（不依赖）。

首先我们定义我们的数据。 我们将加载外部数据，所以我们有一个"loading"属性。
然后根据我们是否成功加载外部数据来追踪"error"和"user"属性。

我们添加一个生命周期挂钩来知道组件何时被挂载，
然后我们使用我们的“site.api”来获取我们的数据。
当我们得到我们的回应时，我们更新错误和用户属性，
然后将加载更新为false。

在我们的模板中，我们对"loading"属性使用绑定，因此只要我们更新"loading"，
该DOM元素和模板就会重新渲染并重新水合。
然后我们决定是否显示错误或用户的详细信息。

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

# [新闻页面](/zh/hackernews?q=news-view)

NewsView稍微复杂一些，因为它包含路由。
NewsView依赖于一个NewsItem组件，所以首先我们加载这个和我们的CSS。
我们的NewsView有额外的数据来协助我们分页我们的应用程序。

我们添加一条类似于我们网站中的路线.App。
这将侦听url中的更改，
以便我们可以跟踪我们尝试加载哪种类型的新闻以及应该加载哪个页面。
当路线符合我们的模式时，将调用"onRoute"方法。

“params”可以在我们的“onRoute”方法中找到。
我们将“@loading”设置为false并重新呈现DOM。
我们加载我们需要的数据，更新我们的状态，然后将“@loading”设置为true，
DOM的那部分也重新渲染。
我们在“加载”属性上使用绑定两次。 一旦在导航中，另一个在下面的内容。
这使我们在更新时不会重新呈现整个导航元素。

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

# [造型](/zh/hackernews?q=styling)

您可能已经注意到我们一直在要求Stylus文件。 柠檬默认支持css和手写笔。
当这些文件发生变化时，柠檬会重新加载我们的页面，
并在我们构建应用程序时编译并将它们捆绑在一起。
我假设你知道css，我们不需要通过源代码。

---

# [开发](/zh/hackernews?q=dev)

```bash
> lemon dev
listening at http://localhost:3000
```

---

# [下一步](/zh/hackernews?q=done)

就这样！ 这个应用程序是用柠檬构建，然后部署到使用柠檬部署的github页面。
请注意，由于这是一个静态托管版本，它只能为主页面（/top，/new, 等）
提供服务器端呈现，因为我们无法知道将来会存在哪些项目标识符和用户标识符。

下一步是创建一个简单的本地服务器，侦听所需的路由，
从请求处理程序中的firebase加载数据，
然后调用lemon.compile以动态加载数据呈现我们的html服务器端。

我们将来会这样做。

https://hackernews.lemonjs.org
