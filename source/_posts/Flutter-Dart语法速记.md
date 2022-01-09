---
title: Flutter-Dart语法速记
date: 2022-01-09 14:09:21
categories: 客户端
---

## Dart 语法速记

### 类型声明

- 静态类型
- var可选类型
- dynamic动态类型
- Object基类声明

```dart
// 静态类型
// 声明变量的时候，使用明确的数据类型
String name = "Jay";
int number = 123;

// var可选类型
// 使用 var 来声明变量，不需要指定变量的明确类型，因为 Dart 会自动推断其数据类型，所以可以使用 var 来定义任何的变量
var content = 'Dart Languge'; 
var switchOn = false;
var current = 123

// dynamic动态类型
// dynamic的意思是数据类型是动态可变的，也可以定义为任何变量，但是和 var 不同的是，var 一旦赋值后，就不能改变数据类型
dynamic example = 'example';
example = 1;// ✅ 这个使用方法正确，因为 dynamic 的类型是动态可变的

// Object 基类声明
// Dart 里所有东西都是对象，是因为 Dart 的所有东西都继承自 Object，因此 Object 可以定义任何变量，而且赋值后，类型也可以更改
Object index = 100;
index = 'string';// ✅ 因为 'String' 也是 Object
```

- late 懒加载

```dart
// 显式声明一个非空的变量，但不初始化
// 如下，_temperature如果不加late关键字，类实例化时此值是不确定的，无法通过静态检查，加上late关键字可以通过静态检查，但由此会带来运行时风险
class Coffee {
  late String _temperature;
  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }
  String serve() => _temperature + ' coffee';
}
main() {
  var coffee = Coffee();
  coffee.heat();
  coffee.serve();
}
// 延迟初始化变量
// 看下面的例子，temperature变量看起来是在声明时就被初始化了，但因为late关键字的存在，如果temperature这个变量没有被使用的话，_readThermometer()这个函数不会被调用，temperature也就不会被初始化了
late String temperature = _readThermometer();
```

- const：在赋值时, 赋值的内容必须是在编译期间就确定下来的
- final：在赋值时, 可以动态获取, 比如赋值一个函数

```dart
// final 关键字
// 在赋值时, 可以动态获取, 比如赋值一个函数
final time1 = DateTime.now();// 正确的做法
final name = 'coderwhy';// 正确的做法
name = 'kobe';// 错误做法

// const 关键字
// 在赋值时, 赋值的内容必须是在编译期间就确定下来的
const age = 18;// 正确的做法
age = DateTime.now();// 错误的做法，因为要执行函数才能获取到值
age = 20; // 错误做法
```

### 内置类型

- int
- double
- String
- bool
- List
- Set
- Map

```dart
// int
var intV = 1;
// double
var doubleV = 1.1;
doubleV += 1;
// String
var str1 = 'string ${1}';
var str2 = 'string $doubleV';
var str3 = '''
str1 = ${str1}
str2 = ${str2}
str3 = \'\'\'str1 + str2 \'\'\'
''';
// List
var list1 = [1,2,3,4];
list1.add(5);
list1[0];
list1.first;
list1.isEmpty;
// Set
var set1 = <int>{};
set1.add(2);
set1.contains(2);
// Map
var map1 = <String, int>{};
map1['key1'] = 1;
map1['key2'] = 2;
map1.keys.toList();
```

### 函数

##### 参数

有两种形式的参数：必要参数 和 可选参数。必要参数定义在参数列表前面，可选参数则定义在必要参数后面。可选参数分为 命名参数 和 位置参数。

```dart
// 函数调用
method1();
method2('a1', 'b1');
method3('a1', 'b1', d: 'd1');
Class1.method4();

// 函数声明
// 无参函数
void method1() {}
// 位置参数函数
void method2(String a, String b, [String c = 'c0', String? d]) {}
// 命名参数函数
void method3(String a, String b, {String c = 'c0', String d = 'd0'}) {}
class Class1 {
  // 静态函数
  static void method4() {}
}
```

##### 函数即对象

```dart
// 函数作用域 与 Java 一致
var insideNestedFunction = false;
var insideMain = true;
void myFunction() {
  var insideFunction = true;
  void nestedFunction() {
    var insideNestedFunction = true;
    assert(insideMain);
    assert(insideFunction);
    assert(insideNestedFunction);
  }
}

// 匿名函数使用
var method1 = (String msg) => '!!! ${msg.toUpperCase()} !!!';
loudify('hello')

// 函数作为对象进行声明
int mehtod2(int element) {
  print(element);
  return 1;
}
void Function(int) method3 = method2;
var method4 = (String msg) => '!!! ${msg.toUpperCase()} !!!';
void method5(void action(int element)) {}

// 函数调用
method4('hello');
method4.call('hello');
Function.apply(method4, ['hello']);

// 函数闭包
Function method5(int addBy) {
  return (int i) => addBy + i;
}
var add4 = method5(4);
var add2 = method5(2);
add2(3); // 5
add4(3); // 7

// 对象相等性
void method6() {}
Function x;
x = method6;
assert(x == method6);
```

### 运算符

##### 类型判断运算符

- as: 类型转换（也用作指定 类前缀）
- is: 如果对象是指定类型则返回 true
- is!: 如果对象是指定类型则返回 false

```dart
Object person = Person();
if (person is Person) {
  person.setName('Bob');
  person.printName();
}

try {
  (person as Person).printName();
} catch (e) {
  print(e);
}
```

##### 级联

.. 或 ?.. 可以让你在同一个对象上连续调用多个对象的变量或方法。

```dart
Paint()
  ..color = Colors.black
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 5.0;
```

##### 空判断


| 语法 | 描述 |
| --- | --- |
| ??= | 也可以使用 ??= 来为值为 null 的变量赋值。 |
| ?. | 与上述成员访问符类似，但是左边的操作对象不能为 null，例如 foo?.bar，如果 foo 为 null 则返回 null ，否则返回 bar。 |
| ?.. | 级联的判空操作，当对象为空时，停止级联后续对象。 |
| 条件 ? 表达式 1 : 表达式 2 | 如果条件为 true，执行表达式 1并返回执行结果，否则执行表达式 2 并返回执行结果。 |
| 表达式 1 ?? 表达式 2 | 如果表达式 1 为非 null 则返回其值，否则执行表达式 2 并返回其值。 |

##### 断言

assert 的第一个参数可以是值为布尔值的任何表达式。如果表达式的值为 true，则断言成功，继续执行。如果表达式的值为 false，则断言失败，抛出一个 AssertionError 异常。

### 异常

Dart 代码可以抛出和捕获异常。与 Java 不同的是，Dart 的所有异常都是非必检异常，方法不必声明会抛出哪些异常，并且你也不必捕获任何异常。

Dart 提供了 Exception 和 Error 两种类型的异常以及它们一系列的子类。但是在 Dart 中可以将任何非 null 对象作为异常抛出而不局限于 Exception 或 Error 类型。

```dart
try {
//    throw Exception();
//    throw OutOfLlamasException();
  throw 'xxxxx';
} on OutOfLlamasException {
  print('OutOfLlamasException');
} on Exception catch (e) { // 可以使用 on 或 catch 来捕获异常，使用 on 来指定异常类型，使用 catch 来捕获异常对象，两者可同时使用
  print('Unknown exception: $e');
  rethrow; // 关键字 rethrow 可以将捕获的异常再次抛出
} catch (e, s) { // 第一个参数为抛出的异常对象，第二个参数为栈信息 StackTrace 对象
  print('Something really unknown: $e stackTrace: $s');
} finally { // finally 语句始终执行，如果没有指定 catch 语句来捕获异常，则异常会在执行完 finally 语句后抛出
  print('try catch to finally');
}
```

### 类

##### 实例

late 关键字主要用于延迟初始化

```dart
class Parent {
  late String _v1;
  late String _v2;

  Parent() {
    _v1 = 'v1';
    _v2 = 'v2';
  }
}
```

##### 构造函数

**构造函数调用**
默认情况下，子类的构造函数会调用父类的匿名无参数构造方法。如需调用指定构造函数，则需要在 构造函数 后加 : 指定需要调用的 父类构造函数。

**初始化列表**
除了调用父类构造函数之外，还可以在构造函数体执行之前初始化实例变量。每个实例变量之间使用逗号分隔。

**构造函数调用顺序**
- 初始化列表
- 父类的无参数构造函数
- 当前类的构造函数

```dart
void main(List<String> arguments) {
  /// 这三者的调用顺序如下
  //  - 初始化列表
  //  - 父类的无参数构造函数
  //  - 当前类的构造函数
  Children().method1();
}

class Parent {
  String _v1 = '';
  String _v2 = '';

  // 默认构造函数
  Parent() {
    print('2 Parent.empty()');
    _v1 = 'v1';
    _v2 = 'v2';
  }

  Parent.copy(Parent o) {
    _v1 = o._v1;
    _v2 = o._v2;
  }
}

class Children extends Parent {
  late String _v3;
  late final String _v4;

  // 生成式构造函数
  // 指定父类的命名式构造函数
  // 初始化列表
  Children() : _v3 = argumentList() {
    print('3 Children()');
    _v3 = 'v3';
    _v4 = 'v4';
  }

  // 命名式构造函数
  // 构造函数重定向
  Children.empty() : this();

  void method1() {
    print('_v3:$_v3 _v4:$_v4');
  }

  static String argumentList() {
    print('0 argument list');
    return 'argumentList';
  }
}
```

##### 工厂构造函数

使用 factory 关键字标识类的构造函数将会令该构造函数变为工厂构造函数，这将意味着使用该构造函数构造类的实例时并非总是会返回新的实例对象。例如，工厂构造函数可能会从缓存中返回一个实例，或者返回一个子类型的实例。

```dart
class Logger {
  static final Map<String, Logger> _cache = <String, Logger>{};

  final String name;

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  factory Logger.fromJson(String name) {
    return Logger(name);
  }

  Logger._internal(this.name);

  void log(String msg) {
    print('$name: msg');
  }
}
```

##### 方法

operator：为了表示重写操作符，我们使用 operator 标识来进行标记。
Getter、Setter： 是一对用来读写对象属性的特殊方法。

```dart
var clazz = Class1('111') + Class1('222');
assets(clazz._name === '111 222');

class Class1 {

  final String _name;
  String value1 = '';

  Class1(this._name);

  // 静态方法
  static String method1() {
    print('method1');
    return 'method1';
  }

  // 实例方法
  String method2() {
    print('method2');
    return 'method2';
  }

  // 运算符重载
  Class1 operator +(Class1 v) {
    return Class1(_name + ' ' + v._name);
  }

  // Getter 和 Setter 方法
  String get value2{
    return value1;
  }
  set value2(String name) {
    value1 = name;
  }
}
```

##### 枚举

使用关键字 enum 来定义枚举类型

```dart
enum Color { red, green, blue }
```

##### 接口和抽象类

override： 可以使用 @override 注解来表示你重写了一个成员。Dart支持重写父类的实例方法（包括 操作符）、 Getter 以及 Setter 方法。

extends、implements： 接口的声明直接通过抽象类来代替。使用 extends 实现继承，使用implements 扩展接口。Dart中 接口是单继承多扩展的。

```dart
// 接口声明
abstract class Printer {
  // 接口函数
  void method3();
}

// 抽象类
abstract class Parent {
  late String _v1;
  late String _v2;
  late String _v3;

  Parent() {
    _v1 = 'v1';
    _v2 = 'v2';
    _v3 = 'v3';
  }

  void method1() {
    print('Parent.mehtod1');
  }

  // 抽象函数
  void method2();
}

// 实现类
class Children extends Parent implements Printer {
  // 属性扩展
  @override
  final String _v3 = 'Children.v3';
  final String _v4 = 'Children.v3';

  Children();

  // 函数扩展
  @override
  void method1() {
    super.method1();
    print('Children.mehtod1');
  }

  // 实现抽象函数
  @override
  void method2() {
    print('Children.mehtod2');
  }

  // 实现接口函数
  @override
  void method3() {
    print('Children.method3');
  }
}

```

##### 混入模式

Mixin 是一种在多重继承中复用某个类中代码的方法模式。

mixin：定义了功能模块。
on：限定了功能模块的使用类型。
with：负责功能模块的组合。

```dart
void main(List<String> arguments) {
  var person = Person();
  person.fly();
  person.run();
  person.swim();
  person.dance();
}

abstract class Animal {}

mixin Walk on Animal {
  void walk() => print('走路');
}

// 通过 mixin 来声明一个混入对象，如果使用 class 的话，构造函数必须不进行声明才行
// 通过 with 来使用混入实例
// 通过 on 进行限定
mixin Dance on Animal, Walk, Run {
  void dance() => print('跳舞');
}

mixin Run on Animal {
  void run() => print('会跑');
}

mixin Fly on Animal {
  void fly() => print('会飞');
}

mixin Swim on Animal {
  void swim() => print('会游泳');
}

class Bird extends Animal with Fly {
  @override
  void fly() {
    super.fly();
  }
}

class Dog extends Animal with Run, Swim {
  @override
  void run() {
    super.run();
  }

  @override
  void swim() {
    super.swim();
  }
}

class Person extends Animal with Run, Swim, Fly, Walk, Dance {}
```

##### 扩展方法

通过 extension ClassB on ClassA 语法来指定对 ClassA 进行扩展方法的定义。

```dart
print('this is log');
'this is log'.log();
'test'.toUpperCasForFirst().log();

extension CostomString on String {
  void log() {
    print('log---> $this ');
  }

  String toUpperCasForFirst() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
```

### 泛型

Dart的泛型类型是固化的，这意味着即便在运行时也会保持类型信息。
与 Java 不同，Java 中的泛型是类型 擦除 的，这意味着泛型类型会在运行时被移除。

```dart
// dart 中的泛型是固化的，运行时，可通过泛型进行类型判断
var names = <String>[];
names.addAll(['str1', 'str2', 'str3']);
assert(names is List<String>);
assert(names is List<bool>);
// 泛型限制使用
var class1 = ClassT<Class2>();
var class2 = ClassT<Class1>();
var class3 = ClassT<String>(); // 编译出错，类型限制
// 函数中使用泛型
method1(<String>['1', '2']);
// 函数
T method1<T>(List<T> ts) {
  return ts[0];
}
// 泛型限制声明
class ClassT<T extends Class1> {}
class Class2 extends Class1 {}
class Class1 {}
```

### 库

以下划线（_）开头的成员仅在代码库中可见。

```dart
// 指定前缀 lib2
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;
Element element1 = Element();
lib2.Element element2 = lib2.Element();
// 导入 lib1 只展示 foo
import 'package:lib1/lib1.dart' show foo;
// 导入 lib2 只隐藏 foo
import 'package:lib2/lib2.dart' hide foo;
```

### 异步

Dart 与 JS 一样都是基于 单线程 + 事件循环 来完成耗时操作的处理。

##### Future 使用

1. 创建一个Future
2. 通过.then(成功回调函数)的方式来监听 Future 内部执行完成时获取到的结果。
3. 通过.catchError(失败或异常回调函数)的方式来监听Future内部执行失败或者出现异常时的错误信息。

##### async 与 await 使用

1. async 封装的函数必须返回 Future 对象
2. await 用于等待 Futrue 的 then 执行结果
3. 通过在 await 外面包装 try catch 来接收 Future 的 catchError 执行结果。

```dart
void main(List<String> arguments) async {
  // Future 使用
  print('step 1');
  var future = method1();
  future.then((value) {
    print('step 3 then');
  }).catchError((error) {
    print('step 3 catchError');
  });
  print('step 2');
  // async await 使用
  try {
    print('step 1');
    var result = await method1();
    print(result);
    print('step 3');
  } catch (e) {
    print(e);
  }
  // Future then 迭代操作
  print('step 1');
  method1().then((value) {
    print(value);
    return 'step 4 then';
  }).then((value) {
    print(value);
    return 'step 5 then';
  }).then((value) {
    print(value);
    return 'step 6 then';
  }).then((value) {
    print(value);
    return 'step 7 then';
  }).catchError((error) {
    print('step 3 catchError');
  });
  print('step 2');
  // Future 内置快捷操作
  Future.value("step 1").then((value) {
    print(value);
  });
  Future.error("step 2").catchError((value) {
    print(value);
  });
  Future.delayed(Duration(seconds: 3), () {
    return "step 2";
  }).then((value) {
    print(value);
  });
}

Future<String> method1() {
  return Future<String>(() {
    sleep(Duration(seconds: 3));
     return "step result";
//    throw Exception("网络请求出现错误");
  });
}
```

### 类型别名

typedef 类型别名是引用某一类型的简便方法。

```dart
// 类定义
typedef IntList = List<int>;
IntList il = [1, 2, 3];
typedef ListMapper<X> = Map<X, List<X>>;
Map<String, List<String>> m1 = {};
ListMapper<String> m2 = {};
// 函数定义
typedef Compare<T> = int Function(T a, T b);
int sort(int a, int b) => a - b;
assert(sort is Compare<int>); // True!
```

### 参考

https://dart.cn/guides/language/language-tour

