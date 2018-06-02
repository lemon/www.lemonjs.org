# [安装](/zh/clock?q=installation)

```bash
# 用npm在全球范围内安装lemon-cli
> npm install -g lemonjs-cli
```

---

# [创建一个项目](/zh/clock?q=create)

```bash
# 为您的新项目创建一个目录
> mkdir -p ~/lemon-clock
> cd ~/lemon-clock

# 从现有的Lemon.js模板创建您的新项目
> lemon new clock-clock-app
```

---

# [项目结构](/zh/clock?q=structure)

```bash
# 简要概述项目结构
> find .
.
./lemon.cson          # 包含您的Lemon.js配置
./README.md           # 项目自述文件
./src                 # 源代码目录
./src/App.coffee      # 你的应用
./src/App.css         # 造型
./src/index.coffee    # 索引页面
```

---

# [项目配置](/zh/clock?q=config)
### (lemon.cson)

```coffeescript
{
  name: "Lemon clock"                # 您的应用的名称
  dev: {
    port: 3000                       # 在端口3000上收听
  }
  prod: {
    hostname: 'clock.lemonjs.org'    # 您的应用将被部署到的主机名
  }
}
```

"prod.hostname"是您的网站最终将位于的网址。
此属性在应用程序中的任何地方都可用作"site.hostname"。 "name"是您的项目的名称。
"dev.port"是您的本地开发服务器将使用的端口。

[了解有关CSON的更多信息](https://github.com/bevry/cson)

---

# [索引页面](/zh/clock?q=index)
### (src/index.coffee)

```coffeescript
# 软件依赖关系
require './App'

# 模板
module.exports = ->
  doctype 5
  html ->
    head ->
      title 'Lemon clock'
    body ->
      site.App()
```

注意我们如何使用“site.App”访问我们的应用程序。 大多数，即使不是全部，
组件应该以这种方式命名空间。 在App.coffee中，你会的
看看我们如何定义命名空间。

这个模板可能会让你想起HTML。 这是CoffeeScript模板。
它看起来很漂亮，而且工作起来非常简单和灵活。
您可能已经注意到我们实际做的是用名称'doctype'，'html'，'head'，
'title'和'site.App'来调用函数。
我们将一个对象（元素属性）和一个函数（元素的内部内容）传递给函数。
这将被编译为JavaScript，并在服务器和浏览器上运行以呈现HTML。
“site.App（）”正在加载你的第一个柠檬组件。 我们来看看它是如何工作的。

CoffeeScript模板有着悠久的历史
[Coffeekup](https://github.com/mauricemach/coffeekup),
[Coffeecup](https://github.com/gradus/coffeecup),
[Teacup](https://github.com/goodeggs/teacup).
[Lemoncup](https://github.com/lemon/lemoncup).

---

# [你的应用](/zh/clock?q=app)
### (src/App.coffee)

```coffeescript
# 样式表
require './css/App.css'

# 浏览器组件
module.exports = lemon.Component {

  # “package”为我们的组件分配一个名称空间
  package: 'site'

  # "name"在我们的命名空间中为我们的组件分配一个名称
  name: 'App'

  # "id"会为我们的组件添加一个DOM标识符
  id: 'app'

  # 我们组件的默认数据
  data: {
    time: Date.now()
  }

  # 生命周期挂钩
  lifecycle: {

    # 听着安装完成
    # 启动一个计时器
    mounted: ->
      @interval_id = setInterval ( =>
        @time = Date.now()
      ), 1000

    beforeDestroy: ->
      clearInterval @interval_id
  }

  # 这是我们绘制到DOM的模板
  # 通过使用"_on"属性，我们可以监听"time"属性的实时更改
  template: (data) ->
  div _on: 'time', _template: (time) ->
    new Date(time).toLocaleTimeString()

}
```

---

# [造型](/zh/clock?q=styling)
### (src/App.css)

```css
#app {
  align-items: center;
  display: flex;
  font-family: monospace;
  font-size: 60px;
  height: 100vh;
  justify-content: center;
}
```

这里我们为我们的项目加载了一个样式文件。
目前Stylus也被支持，LESS和SASS支持会在有人请求时立即提供。

---

# [开发](/zh/clock?q=dev)

```bash
> cd ~/dev/lemon-clock
> lemon dev
listening at http://localhost:3000
```

---

# [预习](/zh/clock?q=test)
### [http://localhost:3000](http://localhost:3000)
 
它应该看起来像这样

<div lemon-component="site.Clock"></div>

---

# 下一步

## 做高级教程 (Hackernews)

这是一个好的开始，但你可以用柠檬做更多的事情。
要获得更高级的教程，请转到[HackerNews](/zh/hackernews)教程。
