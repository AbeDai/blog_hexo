---
title: Effective-Java-通用程序设计
date: 2018-09-29 18:51:06
categories: 客户端
---

## 将局部变量的作用域最小化

将局部变量的作用域最小化，使代码减少出错，更加可读。

- 降低出错的可能性
	> 如果变量在它的目标使用区域之前或者之后被意外地使用的话，会产生意想不到的错误。示例如下：
	
	```
	// 错误示范
	Iterator<Element> i = c.iterator();
	while(i.hasNext()){
		doSomething(i.next());
	}
	···
	Iterator<Element> i2 = c2.iterator();
	// BUG，误将i2写成了i，导致不必要的错误
	while(i.hasNext()){
		doSomethingElse(i2.next);
	}

	// 提供作用域的最小范围，可以避免此类错误的发生
	;
	for(Iterator<Element> i = c.iterator(); i.hasNext(); ){
		doSomething(i.next());
	}
	···
	for(Iterator<Element> i = c2.iterator(); i.hasNext(); ){
		doSomethingElse(i.next);
	}
	```

- 增强可读性
	> 将变量放在使用之前声明，会分散读者注意力。等到用到该变量的时候，读者可能已经记不起该变量的类型和初始值了。

## for-each循环优先于传统的for循环
能用for-each循环实现功能的情况下，尽量使用for-each循环。
- for-each循环内部帮你维护了迭代器，降低了自己维护迭代器产生错误的风险。
- for-each循环让代码变得尽量简洁，提高代码可读性。

## 如果需要精确的数值，请避免使用float和double
- float和double类型，并没有提供完全精确的结果。所以不应该被用于需要精确结果的场合。尤其不适合用于货币计算，最好用int，long或BigDecimal代替。

## 基本类型优先于装箱基本类型
能用基本类型就尽量使用基本类型。装箱基本类型存在以下缺点：
- 两个装箱基本类型，存在相同的数值，却只想不同的内存对象。进行比较时，需要调用equil，同时还需考虑NullPointException异常。提高了使用的成本，加大了在开发中出错的风险。
- 基本类型比装箱基本类型更节省内存空间，在进行运算操作时也更节省运行时间。装箱基本类型可能会存在频繁的装箱和拆箱。

