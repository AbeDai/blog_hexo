---
title: Node-Koa中间件的洋葱圈模型
date: 2019-01-29 20:33:25
tags: 全栈
---

## Koa洋葱圈模型
Koa的中间件选择了洋葱圈模型。中间件结构如下所示：
![](/image/koa_middleware.png)

所有的请求经过一个中间件的时候都会执行两次，Koa 的洋葱圈模型可以非常方便的实现后置处理逻辑。

## Koa洋葱圈实例
```javascript
const Koa = require('koa');

// 构建koa实例
const app = new Koa();

// 添加中间件
app.use(async (ctx, next) => {
  console.log('1-start');
  await next();
  console.log('1-end');
});
app.use(async (ctx, next) => {
  console.log('2-start');
  await next();
  console.log('2-end');
});
app.use(async (ctx, next) => {
  console.log('3-start');
  await next();
  console.log('3-end');
});

// 启动服务
app.listen(3000);

----> 打印结果：
----> 1-start
----> 2-start
----> 3-start
----> 3-end
----> 2-end
----> 1-end
```

## 源码分析
本文重点在于讲解koa中间件的洋葱圈模型。因此，会省略部分无关代码。

#### koa.use方法
use方法，为声明中间件的方法，将中间件存储在middleware数组中。

```javascript
use(fn) {
    if (typeof fn !== 'function') throw new TypeError('middleware must be a function!');

    debug('use %s', fn._name || fn.name || '-');
    this.middleware.push(fn);
    return this;
  }
```

#### koa.listen方法
listen方法，为启动http-server的简便操作。关键操作还是在callback方法上。

```javascript
listen(...args) {
    debug('listen');
    const server = http.createServer(this.callback());
    return server.listen(...args);
  }
```

#### koa.callback方法
callback方法，返回参数为(req, res)的方法，每次http-server发生回调时，都会调用callback方法。因此，callback方法才是真正的koa执行http-server的源头。

```javascript
callback() {
	// 实现洋葱圈的关键代码，从use方法可知，我们将中间件push到了middleware数组中。那么compose方法如何将middleware的数组转换为了洋葱圈模型的方法fn。就是实现洋葱圈模型的关键了。
    const fn = compose(this.middleware);

    const handleRequest = (req, res) => {
      const ctx = this.createContext(req, res);
      return this.handleRequest(ctx, fn);
    };

    return handleRequest;
  }
```

#### koa-compose的compose方法
compose方法，主要作用是将中间件数组，包装成了洋葱圈模型中间件。

```javascript
function compose (middleware) {
  // 校验middleware格式，必须为数组，子元素必须为方法
  if (!Array.isArray(middleware)) throw new TypeError('Middleware stack must be an array!')
  for (const fn of middleware) {
    if (typeof fn !== 'function') throw new TypeError('Middleware must be composed of functions!')
  }

  /**
   * @param {Object} context
   * @return {Promise}
   * @api public
   */

  return function (context, next) {
    // last called middleware #
    let index = -1
    return dispatch(0)
    function dispatch (i) {
      // 正常情况下， index 永远小于 i，除非next()被多次调用。
      if (i <= index) return Promise.reject(new Error('next() called multiple times'))
      index = i
      let fn = middleware[i]
      // 如果next参数存在，则next方法在最后调用。
      if (i === middleware.length) fn = next
      if (!fn) return Promise.resolve()
      try {
      	// 递归调用dispatch方法实现从中间件数组到洋葱圈模型中间件的转变。
        return Promise.resolve(fn(context, dispatch.bind(null, i + 1)));
      } catch (err) {
        return Promise.reject(err)
      }
    }
  }
}
```

#### koa.handleRequest方法
handleRequest方法，消费洋葱圈模型中间件。

```javascript
handleRequest(ctx, fnMiddleware) {
    const res = ctx.res;
    res.statusCode = 404;
    const onerror = err => ctx.onerror(err);
    const handleResponse = () => respond(ctx);
    onFinished(res, onerror);
    // 洋葱圈模型中间件，返回的都是Promise，通过下面代码消费中间件
    return fnMiddleware(ctx).then(handleResponse).catch(onerror);
  }
```


## 参考
https://eggjs.org/zh-cn/intro/egg-and-koa.html
https://www.jianshu.com/p/5d0f1d9ef746

