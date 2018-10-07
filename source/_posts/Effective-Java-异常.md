---
title: Effective Java 异常
date: 2018-10-01 22:19:13
categories: 客户端
---

## 只针对异常情况才使用异常

控制正常流程时不应该使用异常，只有当程序发生异常时才应该抛出Exception。Exception就是来描述程序发生异常的，不要职责不清地让异常来处理非异常的事情。例如下面的for-each循环，不应该用异常来控制循环，而应该用状态测试来控制循环。

```java
// 错误示范，通过异常来控制for-each循环流程
// 通过Iterator.next()的NoSuchElementException来判断循环是否结束
try {
	Iterator<Foo> i = collection.iterator();
	while(true){
		Foo foo = i.next();
	}
} catch (NoSuchElementException e){
    // 终止循环
}
// 正确示范，通过状态测试方法来控制for-each循环流程
// 通过Iterator.hasNext()方法来判断循环是否结束
Iterator<Foo> i = collection.iterator();
while(i.hasNext()){
	Foo foo = i.next();
}
```

## 对于可恢复的情况使用受检异常，对于编程错误使用运行时异常

- 受检异常：如果期望调用者能够适当地恢复，对于这种情况就应该使用受检的异常。例如文件操作后，文件流的关闭操作。
- 非受检异常：如果程序抛出未受检异常或者错误，往往就属于不可恢复的情形，继续执行下去有害无益。例如List.get()的数据越界操作。

## 避免不必要地使用受检异常

当方法存在受检异常时，会给API调用者增加使用成本，例如每次调用该方法时，都要加try-catch代码块。应当少用受检异常。

使用受检异常的原则

- 正确地使用API并不能阻止这种异常条件的产生。参考文件操作，无法保证文件操作不会抛出异常。
- 产生异常后，API调用者可以立即采用有效操作。参考文件操作，文件操作抛出异常后，马上关闭文件，然后执行文件处理失败逻辑。

## 优先使用标准的异常
利用Java提供的标准异常，相当于站在了巨人的肩膀上。可以使你的API更加易于学习，易于使用，更加可读。

## 抛出与抽象相对应的异常
方法抛出的异常，应该与当前方法有联系。上层实现应该捕获下层异常，同时抛出符合上层语义的异常。例如集合中的异常处理示例：

```java
// 将NoSuchElementException改为IndexOutOfBoundException
// 使方法抛出的异常更符合语义，提高了代码的可读性。
public E get(int index){
	ListIterator<E> i = listIterator(index);
	try {
		return i.next();
	} catch (NoSuchElementException e){
		throw new IndexOutOfBoundException("Index:" + index);
	}
}
```

## 异常中包含能捕获失败的信息
异常面向的用户是开发者，异常信息的内容，应该提供异常堆栈信息，异常信息描述的详细内容等。因为异常面向开发者，所以描述信息最好为英文。
