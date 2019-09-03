---
title: chapter9-基础综合案例
categories: 前端
tags:
  - Vue
date: 2019-8-23 14:19:14
---
> [本文转自**vuejs-tutorial**，尊重原创，点击可直接访问原文](https://vuejs.lipengzhou.com/)

# 第 9 章 基础综合案例

- Vue.js
- Vue Router
- Vue CLI
- axios

## 使用 Vue CLI 创建项目

```bash
$ vue create 项目名称
```

## 导入 Bootstrap

1. 安装

```bash
$ npm i bootstrap
```

2. 在 `src/main.js` 中导入

```js
...
import 'bootstrap/dist/css/bootstrap.css'
...
```

> VueCLI 自动将该文件内容生成 style 节点插入了页面的 head 中
>
> 不需要像以前一样在页面中通过 link 标签去加载这个样式了
>
> 一切皆模块！

## 创建视图组件

### 列表页 `src/views/home.vue`

```html
<template>
<div>
  <p>Home Component</p>
</div>
</template>

<script>
export default {
  data () {
    return {}
  }
}
</script>

<style scoped>
</style>

```



### 添加页 `src/views/add.vue`

```html
<template>
<div>
  <p>Add Component</p>
</div>
</template>

<script>
export default {
  data () {
    return {}
  }
}
</script>

<style scoped>
</style>

```



### 编辑页 `src/views/edit.vue`

```html
<template>
<div>
  <p>Edit Component</p>
</div>
</template>

<script>
export default {
  data () {
    return {}
  }
}
</script>

<style scoped>
</style>

```



## 导入并配置 Vue Router

1. 安装

```bash
npm install vue-router
```

2. 创建 `src/router.js` 文件并写入以下内容

```javascript
import VueRouter from 'vue-router'
import Vue from 'vue'

Vue.use(VueRouter)

// 等价于 module.exports = new VueRouter({...})
export default new VueRouter({
  routes: [
  ]
})
```

3. 根据你的需要配置路由表，例如下面分别配置了 Home、Add、Edit 三个路由组件导航规则

```js
import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from './views/Home.vue'
import Add from './views/Add.vue'
import Edit from './views/Edit.vue'

Vue.use(VueRouter)

export default new VueRouter({
  routes: [ // 路由表
    { // 首页
      path: '/',
      component: Home
    },
    { // 添加
      path: '/add',
      component: Add
    },
    { // 修改
      path: '/edit',
      component: Edit
    },
  ]
})

```

4. 在 `src/main.js` 中将路由实例配置到 Vue 实例中

```javascript
...
import router from './router'
...

new Vue({
  render: h => h(App),
  // router: router,
  // es6简写
  router
}).$mount('#app')
```

> 键名 router 是 Vue 实例选项成员（就像 data、methods 一样，固定语法），值 router 是我们在 router.js 中 new 出来的 VueRouter 路由实例

5. 最后，在 `src/App.vue` 中设置路由的出口

```html
<template>
  <div id="app">
    <!-- 路由出口 -->
    <router-view></router-view>
  </div>
</template>
```

6. 回到浏览器中访问不同的路由路径进行测试

## 接口服务

查看 `第4章 和服务端交互/学习准备`

## 功能实现

### 列表展示和删除

安装 `axios`

```bash
$ npm i axios
```

代码：

```html
<template>
<div>
  <div class="header">
    <!-- <button type="button" class="btn btn-primary">Add Hero</button> -->
    <!-- router-link 把 class 传给了自己内部封装的 a 标签了 -->
    <router-link class="btn btn-primary" to="/add">Add Hero</router-link>
  </div>
  <table class="table">
    <thead>
      <tr>
        <th scope="col">ID</th>
        <th scope="col">名称</th>
        <th scope="col">性别</th>
        <th scope="col">定位</th>
        <th scope="col">简介</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="item in heros">
        <th scope="row">{{ item.id }}</th>
        <td>{{ item.name }}</td>
        <td>{{ item.gender }}</td>
        <td>{{ item.type }}</td>
        <td>{{ item.bio }}</td>
        <td>
          <a href="#" @click.prevent="handleDelete(item)">删除</a>
          <router-link :to="'/edit/' + item.id">修改</router-link>
        </td>
      </tr>
    </tbody>
  </table>
</div>
</template>

<script>
// 1. npm install axios
// 2. 哪里使用 axios，哪里就 import axios from 'axios'
import axios from 'axios'

export default {
  data () {
    return {
      heros: []
    }
  },
  created () {
    this.loadHeros()
    // axios({
    //   method: 'GET',
    //   url: 'http://localhost:3000/heros'
    // }).then(res => {
    //   this.heros = res.data
    // })
  },

  methods: {
    loadHeros () {
      axios({
        method: 'GET',
        url: 'http://localhost:3000/heros'
      }).then(res => {
        this.heros = res.data
      })
    },

    handleDelete (item) {
      if (!window.confirm('Are you sure?')) {
        return
      }
      
      axios({
        method: 'DELETE',
        url: `http://localhost:3000/heros/${item.id}`
      }).then(res => {
        this.loadHeros()
      })
    }
  }
}
</script>

<style scoped>
.header {
  padding: 10px;
}
</style>

```



### 添加

```html
<template>
<div>
  <form class="form">
    <div class="form-group">
      <label for="exampleInputEmail1">名称</label>
      <input
        type="email"
        class="form-control"
        id="exampleInputEmail1"
        aria-describedby="emailHelp" placeholder="Enter email"
        v-model="formData.name"
      >
      <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
    </div>
    <div class="form-group">
      <label for="exampleInputEmail1">性别</label>
      <input type="radio" value="男" v-model="formData.gender"> 男
      <input type="radio" value="女" v-model="formData.gender"> 女
    </div>
    <div class="form-group">
      <label for="exampleInputEmail1">定位</label>
      <select v-model="formData.type">
        <option value="刺客">刺客</option>
        <option value="战士">战士</option>
        <option value="辅助">辅助</option>
      </select>
    </div>
    <div class="form-group">
      <label for="exampleInputEmail1">简介</label>
      <textarea cols="30" rows="10" v-model="formData.bio"></textarea>
    </div>
    <button type="submit" class="btn btn-primary" @click.prevent="handleSubmit">Submit</button>
  </form>
</div>
</template>

<script>
import axios from 'axios'

export default {
  data () {
    return {
      formData: {
        name: '',
        gender: '',
        type: '',
        bio: ''
      }
    }
  },

  methods: {
    handleSubmit () {
      axios({
        method: 'POST',
        url: 'http://localhost:3000/heros',
        data: this.formData
      }).then(res => {
        // 跳转到指令路由路径
        // VueRouter 提供的 API，专门用于 JavaScript 导航
        this.$router.push('/')
      })
    }
  }
}
</script>

<style scoped>
.form {
  padding: 10px;
}
</style>

```

### 动态展示编辑页面

1. 修改路由表编辑页面的导航路径

```js
routes: [
  ...
  { 
    path: '/edit/:id',
    component: Edit
  },
  ...
]
```

2. 在 Home.vue 中处理修改按钮的导航地址

```html
...
<td>
  <a href="#" @click.prevent="handleDelete(item)">删除</a>
  <router-link :to="'/edit/' + item.id">修改</router-link>
</td>
...

```

3. 在 `Edit.vue` 编辑页面获取动态路径参数，请求加载数据更新视图

```html
<template>
<div>
  <form class="form">
    <div class="form-group">
      <label for="exampleInputEmail1">名称</label>
      <input
        type="email"
        class="form-control"
        id="exampleInputEmail1"
        aria-describedby="emailHelp" placeholder="Enter email"
        v-model="formData.name"
      >
      <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
    </div>
    <div class="form-group">
      <label for="exampleInputEmail1">性别</label>
      <input type="radio" value="男" v-model="formData.gender"> 男
      <input type="radio" value="女" v-model="formData.gender"> 女
    </div>
    <div class="form-group">
      <label for="exampleInputEmail1">定位</label>
      <select v-model="formData.type">
        <option value="刺客">刺客</option>
        <option value="战士">战士</option>
        <option value="辅助">辅助</option>
      </select>
    </div>
    <div class="form-group">
      <label for="exampleInputEmail1">简介</label>
      <textarea cols="30" rows="10" v-model="formData.bio"></textarea>
    </div>
    <button type="submit" class="btn btn-primary">Submit</button>
  </form>
</div>
</template>

<script>
import axios from 'axios'

export default {
  data () {
    return {
      formData: {
        name: '',
        gender: '',
        type: '',
        bio: ''
      }
    }
  },

  created () {
    // console.log(this.$route.params.id)
    // 不建议在生命周期中写大量的业务代码，最好都封装成 methods 函数
    // 需要的时候直接调用
    this.loadHero()
  },

  methods: {
    loadHero () {
      const id = this.$route.params.id
      axios({
        method: 'GET',
        url: `http://localhost:3000/heros/${id}`
      }).then(res => {
        console.log(res.data)
        this.formData = res.data
      })
    }
  }
}
</script>

<style scoped>
.form {
  padding: 10px;
}
</style>

```



### 提交编辑

```html
<template>
<div>
  <form class="form">
    <div class="form-group">
      <label for="exampleInputEmail1">名称</label>
      <input
        type="email"
        class="form-control"
        id="exampleInputEmail1"
        aria-describedby="emailHelp" placeholder="Enter email"
        v-model="formData.name"
      >
      <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
    </div>
    <div class="form-group">
      <label for="exampleInputEmail1">性别</label>
      <input type="radio" value="男" v-model="formData.gender"> 男
      <input type="radio" value="女" v-model="formData.gender"> 女
    </div>
    <div class="form-group">
      <label for="exampleInputEmail1">定位</label>
      <select v-model="formData.type">
        <option value="刺客">刺客</option>
        <option value="战士">战士</option>
        <option value="辅助">辅助</option>
      </select>
    </div>
    <div class="form-group">
      <label for="exampleInputEmail1">简介</label>
      <textarea cols="30" rows="10" v-model="formData.bio"></textarea>
    </div>
    <button type="submit" class="btn btn-primary" @click.prevent="handleSubmit">Submit</button>
  </form>
</div>
</template>

<script>
import axios from 'axios'

export default {
  data () {
    return {
      formData: {
        name: '',
        gender: '',
        type: '',
        bio: ''
      }
    }
  },

  created () {
    // console.log(this.$route.params.id)
    // 不建议在生命周期中写大量的业务代码，最好都封装成 methods 函数
    // 需要的时候直接调用
    this.loadHero()
  },

  methods: {
    loadHero () {
      const id = this.$route.params.id
      axios({
        method: 'GET',
        url: `http://localhost:3000/heros/${id}`
      }).then(res => {
        console.log(res.data)
        this.formData = res.data
      })
    },
    handleSubmit () {
      const id = this.$route.params.id
      axios({
        method: 'PATCH',
        url: `http://localhost:3000/heros/${id}`,
        data: this.formData
      }).then(res => {
        // 跳转到指令路由路径
        // VueRouter 提供的 API，专门用于 JavaScript 导航
        this.$router.push('/')
      })
    }
  }
}
</script>

<style scoped>
.form {
  padding: 10px;
}
</style>

```

## 编译打包

项目开发完成后，面临的就是如何将项目进行打包上线，放到服务器中。

```bash
npm run build
```

- 打包结果会生成存储到 dist 目录中
- dist 目录
  - css
  - js
  - img
  - ...
  - index.html
- 最后把打包的结果（dist）交给公司负责运维部署人员
  - 运维人员
  - 后端人员
- 负责部署的人员会把打包结果放到一个 Web 服务器容器中去运行
  - nginx
  - Apache
  - tomcat
  - 等常见服务器软件
- 我们可以在本地预览一下打包结果
  - 安装一个全局命令行工具，这个工具可以启动一个静态文件服务器 `npm install -g serve`
  - `serve -s dist` 启动服务
  - 然后预览打包结果文件
- 本地预览测试没有问题之后，把 dist 压缩一下发给负责部署的人员

> 注意：如果打包结果有问题，不要去修改 dist 中的文件，而是修改 src 源码，完了重新打包生成 dist。

## 路由懒加载

参考文档：[官方文档 - 路由懒加载](<https://router.vuejs.org/zh/guide/advanced/lazy-loading.html>)

- 默认情况下你第1次访问这个网站，就会把所有的组件资源都下载好
  - 好处：切换其它组件页面速度非常快
  - 缺点：如果组件页面比较多，会导致第1次加载速度慢
- 如果你想提高第1次的加载速度，就是不要让它一次性的下载所有资源，解决方式就是配置路由懒加载
  - 说白了就是我看哪个页面，才下载哪个页面

## 总结

