---
title: Effective Java 方法设计
date: 2018-09-20 22:27:11
categories: 客户端
---

## 检验参数的有效性
-  应该在方法开头就检验参数的有效性，及时报出参数错误。
	
	> 传递无效参数给方法，这个方法在执行之前先对参数进行检验，那么他很快就会失败，并且清楚地呈现出适当的异常。如果这个方法没有检查他的参数，就有可能发生以下几种情景。该方法可能在处理过程中失败，并且产生令人费解的异常。更糟糕的是，该方法可以正常方法，但是会悄悄地计算出错误结果。最糟糕的是，该方法可以正常返回，但是却使得某个对象处于被破坏的状态，将来在某个不确定的时候，在某个不相关的点上会引发错误。

- public方法的参数校验直接抛出异常，包内方法则使用assert断言校验参数。

	> 对于未被导出方法，作为包的创建者，你可以控制这个方法将在哪些情况下被调用，因此你可以，也应该确保只将有效的参数值传递进来。因此，非公有的方法通常应该使用断言来检查它们的参数。
	
## 必要时进行保护性拷贝
- 方法的入参和出参都需要考虑保护性拷贝。防止外部方法对其进行破坏性操作。这里的外部方法是指使用类的第三方方法。保护性拷贝不是必须的，但是每次在代码的时候，都应该考虑到这一步操作。尤其是写底层库的时候。

	> ```java
	// 入参的保护性拷贝
	public newClass(List<String> args){
		this.list = new ArrayList<String>(args);
	}
	// 出参的保护性拷贝
	public getList(){
		return new ArrayList<String>(this.list);	
	}
	```
	
## 谨慎设计方法签名
- 方法名称很重要，在设计方法名时，应该始终遵守标准的命名习惯。

	> 尽量让自己的方法名看起来像一句话一样。在定好自己的方法名之后，最后写伪代码调用自己的方法，验证方法的可读性。设计底层库时很重要。
	
- 避免过长的方法参数列表。

	> 方法的参数最好不超过4个。如果方法参数真的很长，可以考虑Build模式，让使用者优雅的设值，或者考虑外观类，给复杂的实现方法套一层简单的壳。

- boolean类型参数最好用枚举替代。

	> 这是boolean类型参数的小小建议。如果要在参数中使用boolean类型，最好用枚举类型进行替代。首先枚举更具有可读性，其次枚举更利于以后的扩展。
	
## 慎用重载

- Java语言要调用哪个重载方法是在编译时做出决定的。这一点不符合Java语言的运行时特性。一般情况下，我们认为覆盖操作比较符合Java标准的运行时特性。

	> ```java
	// 重载了classify方法
	public class CollectionClassifier {
		public static String classify(Set<?> s) {
			return "Set";
		}
		public static String classify(List<?> lst) {
			return "List";
		}
		public static String classify(Collection<?> c) {
			return "Unknown Collection";
		}
		public static void main(String[] args) {
			Collection<?>[] collections = { new HashSet<String>(),
					new ArrayList<BigInteger>(),
					new HashMap<String, String>().values() };
			for (Collection<?> c : collections)
				System.out.println(classify(c));
		}
	}
	// 预期是打印出Set，List，Unknown Collection。但是实际上是打印出Unknown Collection，
	// Unknown Collection，Unknown Collection。因为重载是根据编译时决定要调用的是哪个方法。
	```
	> 由于重载容易引起编程时的想法和运行结果不一致。所以，在使用重载编写设计API的时候，应该尽量避免使用。防止API使用者引起误会。如果重载方法的参数的类型有继承关系，例如parse(String content)和parse(Object content)，最好用方法名区分开，paeseString(String content)和parseObject(Object content)。**总之，方法参数数目相同的方法，应该尽量避免重载。**
	
## 返回零长度的集合，而不是null

- 方法返回集合时，如果集合内容为空，则返回一个空的集合对象，而不是null。

	> 因为对于返回null而不是零长度集合的方法来说，每次调用该方法时都需要判断下返回对象是都为null，从而防止NullPointerException，对于方法使用者很不友好。