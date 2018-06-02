
# [Command Line](/en/how-to?q=cli)

---

## [Installation](/en/how-to?q=install)
install lemon globally with npm

```bash
> npm install -g lemonjs-cli
```

---

## [Development](/en/how-to?q=dev)
Run a local dev server with live-reloads on your src and data

```bash
> mkdir your-project
> cd your-project
> lemon new
> lemon dev
```

---

## [Build](/en/how-to?q=build)
This will build your site into the /build directory

```bash
> cd your-project
> lemon build
```

---

## [Run](/en/how-to?q=run)
This will host your site as a static site from the build directory

```bash
> cd your-project
> lemon run
```

---

## [Deploy to Google Cloud Storage](/en/how-to?q=deploy-gcs)
This will deploy your site to a google cloud storage bucket.

1. Purchase your domain name (you can use http://domains.google)
2. Set a CNAME on www.yourdomain.com to c.storage.googleapis.com.
3. Create a bucket with your domain name (www.yourdomain.com)
4. Create a [service account](https://console.cloud.google.com/apis/credentials/serviceaccountkey?_ga=2.170375971.-221606834.1526762983&_gac=1.149573188.1527023101.CjwKCAjw_47YBRBxEiwAYuKdw_SdGVmJAeAppEfMfinv6bvP3RQ7DLeIXKxYRWsZJk0R8I2bqvlJQBoCK2UQAvD_BwE)
  - Service Account Name: deploy
  - Role: Project > Owner
  - Key Type: JSON
6. Update your lemon.cson

```coffeescript
{
  deploy: {
    service: "gcs"
    project: "your-project-id"
    bucket: "www.yourdomain.com"
    credentials: "/absolute/path/to/creds"
  }
}
```

```bash
> cd your-project
> lemon build
> lemon deploy
```

---

## [Deploy to Github Pages](/en/how-to?q=deploy-github)

1. go to your settings page (ex: https://github.com/lemon/lemonjs-cli/settings)
2. change "Source" to "master branch /docs folder". click "Save"
3. enter a custom domain. click "Save"
4. CNAME your domain to YOUR-GITHUB-USERNAME.github.io ([more info here](https://help.github.com/articles/setting-up-a-custom-subdomain/)]
5. Update your lemon.cson

```coffeescript
{
  deploy: {
    service: "github"
  }
}
```

```bash
> cd your-project
> lemon build
> lemon deploy
```

---

## [Deploy to Amazon S3](/en/how-to?q=deploy-s3)

coming soon

---

# [Components](/en/how-to?q=components)

---

## [Component Namespacing](/en/how-to?q=component-namespacing)

Every component requires a "package" and a "name". "package" is
a namespace for your project. For a website, convention is to
use "site" as your package name. For 3rd party libraries, try
to keep them short, but easy to remember. For example, lemon ui
library uses "lui". The lemon material ui library uses "mui". 

```coffeescript
module.exports = lemon.Component {
  package: "site"
  name: "MyComponent"
}
```

---

## [Component Classes](/en/how-to?q=component-classes)

Sometimes you want a component to always have a specific
class name. For example, the lui.Button always adds a 
.lui-button class name to its element for styling. You
can do this on your own components with the "class" property.

```coffeescript
module.exports = lemon.Component {
  package: "site"
  name: "MyComponent"
  class: 'my-component'
}
```

---

# [Templates](/en/how-to?q=templates)

---

## [How to set "id" on an element](/en/how-to?q=ids)

```coffeescript
module.export = lemon.Component {

  template: ->
    div '#my-id-1'
    div id: 'my-id-2'
    div {id: 'my-id-3'}

}
```

---

## [How to set "class" on an element?](/en/how-to?q=classes)

```coffeescript
module.export = lemon.Component {

  template: ->
    div '.my-class-1'
    div class: 'my-class-2'
    div {class: 'my-class-3'}

}
```

---

## [How to set a conditional "class" on an element?](/en/how-to?q=conditional-classes)

```coffeescript
module.export = lemon.Component {

  template: (data) ->
    div class: {
      'my-class': data.if_should_have_class
    }

}
```

---

## [How to set attributes on an element?](/en/how-to?q=attributes)

```coffeescript
module.export = lemon.Component {

  template: (data) ->
    img src: '', alt: ''
    img {src: '', alt: ''}

    div 'data-title': '', ->
      'content'

    div {'data-title': ''}, ->
      'content'
}
```

---

## [How to write raw html in my template?](/en/how-to?q=html)

By default, all data is escaped so that we can be sure to
generate clean, valid html. If you know you have safe html
to write, you can use the `raw` function.

```coffeescript
module.export = lemon.Component {

  template: (data) ->
    code ->
      raw data.html_sample
}
```

---

## [How to write content without an element?](/en/how-to?q=text)

Sometimes you want to write text to your dom at the same level of
depth as other elements. This is common when you're using spans
to do styling on a subtitle or metadata line. The `text` function
can be used to write this text.

```coffeescript
module.export = lemon.Component {

  template: (data) ->
    div '.blog-post', ->
      div '.author', ->
        data.author
      div '.metadata', ->
        text "Published on "
        span '.published-on', ->
          data.published_at
        text " in category"
        span '.category', ->
          data.category
}
```

---

## [My template is crashing says xxx tag not defined?](/en/how-to?q=custom-tags)

Not 100% of tags are readily available. Sometimes this is for namespace safety,
or maybe it's just not a common tag to use so we didn't include it. If you
think a tag is missing that should be added, let us know.

Also, sometimes you're using WebComponents you may have non-standard
tags that you're using.

Either way, you can use the `tag` function to use any tag you want.

```coffeescript
module.export = lemon.Component {

  template: (data) ->
    tag 'emoji-rain', {active: true}
    tag 'app-drawer'
}
```

---

# [Data](/en/how-to?q=data)

---

## [When should I use "static" data?](/en/how-to?q=static-data)

Most of the time you will use static. In most apps, a majority
of the interface is based on items that don't react to events
or data changes. All of the page content, the header, the
footer, and sidebar list items of this site are static. 

For example, once the sidebar on the left is drawn, it doesn't need
to be updated again. 

---

## [When should I use "dynamic" data?](/en/how-to?q=dynamic-data)

Sometimes you'll have a component with constantly changing data
and you'll want dom elements to react in real-time to your data
changes.

Here's an example of lemon-ui's Typewriter component. The state of the
component changes while it animates, and the UI updates in real-time to
react to these changes is state.

<div lemon-component="site.TypewriterExample"></div>

---

# [Data Binding (Dynamic Data)](/en/how-to?q=data-binding)

---

## [Binding Text](/en/how-to?q=binding-text)

If you have a string value property that you want to react
to real-time state changes. you can use text-binding.

```coffeescript
module.exports = lemon.Component {

  data: {
    property: 'value'
  }

  template: ->

    div bind: {text: 'property'}

    div _text: 'property'

    div _on: 'property', _template: (property) ->
      text property

}

```

---

## [Binding HTML](/en/how-to?q=binding-html)

If you have an html blob that you want to react
to real-time state changes. you can use html-binding.

```coffeescript
module.exports = lemon.Component {

  data: {
    code_sample: '<div>hello world</div>'
  }

  template: ->

    div bind: {html: 'code_sample'}

    div _html: 'code_sample'

    div _on: 'property', _template: (code_sample) ->
      raw code_sample

}

```

---

## [Binding href attributes](/en/how-to?q=binding-href)

If you have a url property that you want to react
to real-time state changes. you can use href-binding.

```coffeescript
module.exports = lemon.Component {

  data: {
    my_href: 'http://www.lemonjs.org'
  }

  template: ->
    a bind: {href: 'my_href'}
    a _href: 'my_href'

}

```

---

## [Binding src attributes](/en/how-to?q=binding-src)

If you have an image url property that you want to react
to real-time state changes. you can use href-binding.

```coffeescript
module.exports = lemon.Component {

  data: {
    my_image: 'http://www.lemonjs.org/img/test.jpg'
  }

  template: ->
    img bind: {src: 'my_image'}
    img _src: 'my_image'

}

```

---

## [Binding templates](/en/how-to?q=binding-templates)

Sometimes you want partial updates, but you want to render
something more complex than the value of the field. In that case,
you can use template-binding.

```coffeescript
module.exports = lemon.Component {

  data: {
    active_tab: 'tab1'
    tab_content: {
      tab1: 'hello world'
    }
  }

  template: ->
    div '.tab-wrapper', _on: 'active_tab', _template: (active_tab, data) ->
      div '.tab-header', ->
        active_tab
      div '.tab-content', ->
        data.tab_content[active_tab]
          
}

```

---

## [Binding Components](/en/how-to?q=binding-components)

Sometimes you want to bind on not just a template, but a 
full component with its own event handling and data management.
In this case, you can use component-binding.

```coffeescript
require '../components/CodeBlock'

module.exports = lemon.Component {

  data: {
    code_sample: '<div>hello world</div>'
  }

  template: ->
    div _on: 'code_sample', _component: site.CodeBlock

}

```

## [Binding Lists](/en/how-to?q=binding-lists)

If you're managing lists, it's not efficient to re-mount
the entire list everytime one item is added or removed from
the list. Lemon has `list-binding` to solve this problem. As
your list is modified, the dom will only modify the newly added
or removed elements.

```coffeescript
require '../components/ListItem'

module.exports = lemon.Component {
  package: 'site'
  name: 'List'

  data: {
    items: []
  }

  template: ->
    div _list: 'items', _component: site.ListItem

}

```

---

# [Event Handling](/en/how-to?q=event-handling)

---

## [How do I listen for a click event on an element?](/en/how-to?q=click-event)

```coffeescript
module.exports = lemon.Component {
  package: 'site'
  name: 'ClickTestComponent'

  methods: {
    onClick: (e) ->
      alert 'clicked!'
  }

  template: ->
    div $click: 'onClick', ->
      'click me'
}
```

Sometimes it may be more convenient to put the event handler inline.
```coffeescript
module.exports = lemon.Component {
  package: 'site'
  name: 'ClickTestComponent'

  template: ->
    div {$click: -> alert 'clicked!'}, ->
      'click me'
}
```

---

## [How do I listen for events on the entire component?](/en/how-to?q=component-events)

you can manually add a listener after mount

```coffeescript
module.exports = lemon.Component {
  package: 'site'
  name: 'SomeComponent'

  lifecycle: {
    mounted: ->
      @addEventListener @el, 'click', (e) => @onClick e
  }

  methods: {
    onClick: (e) ->
      console.log e
  }

  template: (data) ->

```

---


# [Routing](/en/how-to?q=routing)

---

## [Direct Match Routing](/en/how-to?q=direct-match)

Use direct match routing to match a pathname exactly.

```coffeescript
module.exports = lemon.Component {
  template: ->
    lemon.Router {
      '/en/how-to': ->
    }
}
```

---

## [Named Parameters](/en/how-to?q=named-parameters)

Use named paramter routing to pull fields out of your url.

```coffeescript
module.exports = lemon.Component {
  template: ->
    lemon.Router {
      '/video/:id': (match) ->
        # load VideoPage component which loads data from your api
        # with match.params.id
    }
}
```

---

## [Expression Parameters](/en/how-to?q=expression-parameters)

Often when you want some flexibility in a part of your url, but
you don't want to let it be anything. In this case you can use
expression paramters.

```coffeescript
module.exports = lemon.Component {
  template: ->
    lemon.Router {
      '/(en|zh)/how-to': -> # load how to page in given language
      '/video/([0-9]+)': -> # all video ids should be integers
    }
}
```

---

## [Named Expression Parameters](/en/how-to?q=named-expression-parameters)

Usually if you have an expression, you'll want to capture its value
to use in your component.

```coffeescript
module.exports = lemon.Component {
  template: ->
    lemon.Router {
      '/(en|zh):lang/how-to': -> # load how to page in given language
      '/video/([0-9]+):id': -> # all video ids should be integers
    }
}
```

---

## [Splat Parameters](/en/how-to?q=splat-parameters)

Named parameters can't match across forward slashes, if you
want to do that, you can use splat paramters `*`, which will
match everything to the end of the url

```coffeescript
module.exports = lemon.Component {
  template: ->
    lemon.Router {
      '/en/*': -> # match all /en... pages
    }
}
```

---

## [Query String](/en/how-to?q=querystring)

The querystring is also parsed and available in your routes.

```coffeescript
module.exports = lemon.Component {
  template: ->
    lemon.Router {
      '/en/how-to': (match) -> match.query
    }
}
```

---

## [Hash](/en/how-to?q=hash)

The url hash is also available in your routes.

```coffeescript
module.exports = lemon.Component {
  template: ->
    lemon.Router {
      '/en/how-to': (match) -> match.hash
    }
}
```

---

# [Coffeescript](https://coffeescript.org/)

Visit https://coffeescript.org/ to learn about coffeescript.

---

# [CSON](https://github.com/bevry/cson)

Visit https://github.com/bevry/cson to learn about coffeescript.

---




# [Can I Use](/en/how-to?q=can-i-use)

---

## [Can I use Jquery?](/en/how-to?q=jquery)

Of course! Lemon has build in methods for finding elements,
listening to events, and modifying the dom. So you probably
only need jquery if you want to use jquery plugins. Simply
add jquery to your head tag.

### index.coffee
```coffeescript
module.exports = ->
  doctype 5
  head ->
    script src: 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js'
  body ->
    "Your App"
```

---

## [Can I use Jquery FullPage?](/en/how-to?q=jquery-fullpage)

Of course! You can use it manually, or use lemon-ui's built-in
Jquery FullPage Component.

### option 1
```coffeescript
module.exports = ->
  doctype 5
  html ->
    head ->
      script src: 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js'
      script src: 'https://cdnjs.cloudflare.com/ajax/libs/fullPage.js/2.9.7/jquery.fullpage.min.js'
      link {
        rel: "stylesheet"
        type: "text/css"
        href: 'https://cdnjs.cloudflare.com/ajax/libs/fullPage.js/2.9.7/jquery.fullpage.min.css'
      }
    body ->
      div id: "fullpage", ->
        div '.section', -> 'section 1'
        div '.section', -> 'section 2'
        div '.section', -> 'section 3'
        div '.section', -> 'section 4'
      script type: 'text/javascript', """
        $(document).ready(function() {
          $('#fullpage').fullpage();
        });
      """
```

### option 2
```coffeescript
require 'lemonjs-lui/FullPage'

module.exports = ->
  doctype 5
  html ->
    body ->
      lui.FullPage {
        sections: [
          (-> text 'section 1')
          (-> text 'section 2')
          (-> text 'section 3')
          (-> text 'section 4')
        ]
      }
```

---

## [Can I use bootstrap?](/en/how-to?q=bootstrap)

Yes! Sample coming soon.

---

## [Can I use materialize?](/en/how-to?q=materialize)

Yes! Sample coming soon.

---
