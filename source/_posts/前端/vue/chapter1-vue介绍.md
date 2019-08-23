---
title: chapter1-vue介绍
img: https://cn.vuejs.org/images/logo.png
categories: 前端
tags:
  - Vue
date: 2019-08-21 17:54:36
---

# 第 1 章 Vue.js 介绍

## 疯狂发展的前端技术

- 前端开发的三个时代
  - 纯原生 JavaScript
  - jQuery（仅仅是提高了 DOM 操作的效率）
  - 框架时代

- 前端交互越来越多，功能需求越来越复杂；旧浏览器逐渐淘汰，移动端需求增加
- 架构由传统的后台 MVC 向 REST API + MV\* 发展
  - 以前：胖服务器，瘦客户端
  - 现在：胖客户端，瘦服务器‘

- 前后端分离开发方式
  - 人员职责的划分
  - 技能的划分

- 各种前端框架诞生
  - Vue
  - React
  - Angular
  - ...

## 是什么

以下引自官网原话：

> Vue.js (读音 /vjuː/，类似于 view) 是一套构建用户界面的渐进式框架。
> 与其他重量级框架不同的是，Vue 采用自底向上增量开发的设计。
> Vue 的核心库只关注视图层，它不仅易于上手，还便于与第三方库或既有项目整合。
> 另一方面，当与单文件组件和 Vue 生态系统支持的库结合使用时，Vue 也完全能够为复杂的单页应用程序提供驱动。

- 一款非常优秀的前端渐进式 JavaScript 框架
  - Vue 本身只是一个用于数据驱动视图更新的库
    - 让你原来操作 DOM 这件事儿更简单了
  - 随着生态的慢慢发展，如今已经有了 Vue Router、Vuex、Vue CLI、Vue Server Renderer 等功能库，所以当 Vue 和这些核心功能库结合到一起的时候，我们称之为一个框架
  - 这些技术一般也称之为 Vue 全家桶，所以学习 Vue 实际上就是要学习 Vue 全家桶才能发挥出 Vue 的威力
- 由尤雨溪开发并于 2014 年 2 月开源于 Github
  - 目前已收货了 14w+ :star:
- 可以轻松构建 **SPA 应用程序**
  - Single Page Application 单页面应用程序
- 通过 **指令** 扩展了 HTML，通过 **表达式** 绑定数据到 HTML
- 通过组件化开发极大的提高了开发的效率和可维护性
- **最大程度上解放了 DOM 操作**
- **它能让你更加的享受编程的乐趣**

------

## 发展历史

> [Github 发布记录](https://github.com/vuejs/vue/releases)

- Vue.js 由尤雨溪个人正式发布于 2014 年 2 月，并开源于 Github
- 2015 年 10 月 27 日，正式发布 `1.0`
- 2016 年 8 月 1 日，正式发布 `2.0`
- 截止到 2019-6 目前最新版本为 `2.6.10`
- 预计今年（2019）会发布 3.0 版本
- 目前已在 Github 收获 14w+ Star

------

## Vue 核心思想

Vue 是为了克服 HTML 在构建应用上的不足而设计的。Vue 有着诸多特性，最为核心的是：

- **数据驱动**
  - DOM 是数据的一种自然映射
  - 数据改变自动驱动视图更新
- **组件化**
  - 扩展 HTML 元素，封装可重用代码

![mvvm](./chapter1-vue介绍/mvvm.png)

![components.png](./chapter1-vue介绍/components.png)

## 相关链接

- [Vue Github 仓库](https://github.com/vuejs/vue)
- [Vue 中文官网](https://cn.vuejs.org/)
- [Vue 官方教程](https://cn.vuejs.org/v2/guide/)
- [Vue 官方 API 参考文档](https://cn.vuejs.org/v2/api/)
- [Vue 官方示例](https://cn.vuejs.org/v2/examples/)
- [awesome-vue](https://github.com/vuejs/awesome-vue)

- https://gitee.com/gitee-stars/14)