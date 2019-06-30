---
title: TypeScript-基础语法
date: 2019-06-11 08:18:22
tags: 全栈
---

## 简介

TypeScript 是一种由微软开发的自由和开源的编程语言。它是 JavaScript 的一个超集，而且本质上向这个语言添加了可选的静态类型和基于类的面向对象编程。

作为从 Java 迁移过来的开发者，感觉 TypeScript 真的是搭救我从 JavaScript 的大坑中出来的神器呢~
再也不用担心因为类型不安全而导致编码不严谨的各式各样的问题了。

## 基本类型

```
// 布尔值
let isDone: boolean = false;
// 数字
let num: number = 6;
// 字符串
let name:string = "bob";
let sentence: string = `Hello, my name is ${name}`;
// 数组
let list: number[] = [1, 2, 3, 4];
let list: Array<number> = [1, 2, 3];
// 枚举
enum Color { Red, Green, Blue };
let c: Color = Color.Green;
// Symbols：与javascript同意义
let sym1 = Symbol();
let sym2 = Symbol();
// Any：可以理解为Object对象
let notSure: any = 4;
notSure = "maybe a string instead";
notSure = false;
// Void：表示没有任何类型
function warnUser(): void {
    console.log("This is my warning message");
}
// Null & Undifined：~ extend from javascript
let u: undefined = undifined;
let n: null = null;
// Never：表示一个永远无法达到的类型
function error(message: string): never {
    throw new Error(message);
}
// Object：表示非原始类型，即除number，string，boolean，symbol之外的类型
function create(o: object): void;
create({ prop: 0 });// ok
create(1);// error
// 类型断言：类似于java中的类型强转
let someValue: any = "this is a string";
let strLenght1: number = (<string>someValue).lenght;
let strLenght2: number = (someValue as string).lenght;
```

## 变量声明

```
// 声明
var str1 = "string 1";
let str2 = "string 2";
const str3 = "string 3";
// 解构-数组
let input = [1, 2];
let [first, second] = input;
console.log(first);// output -> 1
console.log(second);// output -> 2
// 解构-对象
let o = {
    a: "foo",
    b: 12,
    c: "bar",
}
let { a, b } = o;
console.log(a);// output -> foo
console.log(b);// output ->12
// 展开-数组
let first = [1, 2];
let second = [3, 4];
let bothPlus = [ 0, ...first, ...second, 5];
// 展开-对象
let defaults = { food: "spicy", price: "$$", ambiance: "noisy" };
let search = { ...defaults, food: "rich" };
```

## 接口

**接口-标准使用：没有对象实现接口的概念，只是一个类型检查**

```
// 声明接口
interface LabelledValue {
  label: string;
}
// 实现接口
function printLabel(labelledObj: LabelledValue) {
  console.log(labelledObj.label);
}
// 使用接口
let myObj = {size: 10, label: "Size 10 Object"};
printLabel(myObj);
```

**接口-可选属性**

```
interface SquareConfig {
  color?: string; // 可选参数
  width?: number; // 可选参数
}
```

**接口-只读属性**

```
// 声明
interface Point {
  readonly x: number;
  readonly y: number;
}
// 使用
let p1: Point = { x: 1, y: 2 };
p1.x = 1;// error
```

**接口-声明函数：声明函数时，会生成一个方法签名；规则与 java 基本相同**

```
// 声明
interface SearchFunc {
  search(source: string, subString: string): boolean;
}
// 使用
let mySearch: SearchFunc = {
  search: function(source: string, subString: string): boolean {
    let result = source.search(subString);
    return result > 0;
  }
};
```

**接口-实现接口：与 java 中的接口基本作用一样**

```
// 声明
interface ClockInterface {
  currentTime: Date;
  setTime(d: Date): void;
}
// 实现
class Clock implements ClockInterface {
  currentTime: Date;
  // 构造方法
  constructor(h: number, m: number) {
    this.currentTime = new Date();
    this.currentTime.setHours(h, m);
  }
  // 接口方法
  setTime(d: Date): void {
    this.currentTime = d;
  }
}
```

**接口-多继承：操作方法与 java 类似**

```
// 声明
interface Shape {
  color: string;
}
interface PenStroke {
  penWidth: number;
}
// 声明多继承接口
interface Square extends Shape, PenStroke {
  sideLength: number;
}
// 使用
let square: Square = {
  color: 'blue',
  sideLength: 10,
  penWidth: 5.0
};
```

**接口-继承与类的接口：当接口继承了一个类类型时，它会继承类的成员但不包括其实现，接口同样会继承到类的 private 和 protected 成员。**

```
class Control {
    private state: any;
}

interface SelectableControl extends Control {
    select(): void;
}

class Button extends Control implements SelectableControl {
    select() { }
}

class TextBox extends Control {
    select() { }
}

// 错误：“Image”类型缺少“state”属性。
class Image implements SelectableControl {
    select() { }
}

// 错误：“Image”类型缺少Control类的“state”属性。
class Location implements SelectableControl {
    private state: any;// 此 state 非彼 state
    select() { }
}
```

## 类

**类-创建**

```
class Greeter {
    greeting: string;
    constructor(message: string) {
        this.greeting = message;
    }
    greet() {
        return "Hello, " + this.greeting;
    }
}

let greeter = new Greeter("world");
```

**类-继承**

```
class Animal {
  move(distanceInMeters: number = 0) {
    console.log(`Animal moved ${distanceInMeters}m.`);
  }
}

class Dog extends Animal {
  bark() {
    console.log('Woof! Woof!');
  }
}

const dog = new Dog();
dog.bark();
dog.move(10);
dog.bark();
```

**类-修饰符：公共，私有与受保护的修饰符**

- public：默认值，表示可以类的外部访问
- private：当成员被标记成 private 时，它就不能在声明它的类的外部访问
- protected：protected 修饰符与 private 修饰符的行为很相似，但有一点不同， protected 成员在派生类中仍然可以访问

```
class Person {
  protected name: string;
  private age: number;
  protected constructor(theName: string) {
    this.name = theName;
    this.age = 18;
  }
}

class Employee extends Person {
  private department: string;
  /* public */ constructor(name: string, department: string) {
    super(name);
    this.department = department;
    this.age = 24; // error: Person的age属性为private
  }

  public getElevatorPitch() {
    return `Hello, my name is ${this.name} and I work in ${this.department}.`;
  }
}

let howard = new Employee('Howard', 'Sales');
let john = new Person('John'); // error: Persion的构造函数为protected
```

**类-readonly 修饰符：将属性设置为只读的。 只读属性必须在声明时或构造函数里被初始化。**

```
class Octopus {
  readonly name: string;
  readonly numberOfLegs: number = 8;
  constructor(theName: string) {
    this.name = theName;
  }
}
let dad = new Octopus('Man with the 8 strong legs');
dad.name = 'Man with the 3-piece suit'; // 错误! name 是只读的.
```

**类-存取器：TypeScript 支持通过 getters/setters 来截取对对象成员的访问。 它能帮助你有效的控制对对象成员的访问**

```
class Employee {
  fullName: string = 'empty';
}

let employee = new Employee();
employee.fullName = 'Bob Smith';
if (employee.fullName) {
  console.log(employee.fullName);
}

// 存取器转化 ===>

class Employee {
  private _fullName: string = 'empty';

  get fullName(): string {
    return this._fullName;
  }

  set fullName(newName: string) {
    this._fullName = newName;
  }
}

let employee = new Employee();
employee.fullName = 'Bob Smith';
if (employee.fullName) {
  console.log(employee.fullName);
}
```

**类-静态属性**

```
class Grid {
  static origin = { x: 0, y: 0 };
  calculateDistanceFromOrigin(point: { x: number; y: number }) {
    let xDist = point.x - Grid.origin.x;
    let yDist = point.y - Grid.origin.y;
    return Math.sqrt(xDist * xDist + yDist * yDist) / this.scale;
  }
  // 构造函数-参数：scale 为声明成员属性的另一种方式
  constructor(public scale: number) {}
}

let grid1 = new Grid(1.0); // 1x scale
let grid2 = new Grid(5.0); // 5x scale

console.log(grid1.calculateDistanceFromOrigin({ x: 10, y: 10 }));
console.log(grid2.calculateDistanceFromOrigin({ x: 10, y: 10 }));
```

**类-抽象类：abstract 关键字是用于定义抽象类和在抽象类内部定义抽象方法**

```
abstract class Department {

    constructor(public name: string) {
    }

    printName(): void {
        console.log('Department name: ' + this.name);
    }

    abstract printMeeting(): void; // 必须在派生类中实现
}

class AccountingDepartment extends Department {

    constructor() {
        super('Accounting and Auditing'); // 在派生类的构造函数中必须调用 super()
    }

    printMeeting(): void {
        console.log('The Accounting Department meets each Monday at 10am.');
    }

    generateReports(): void {
        console.log('Generating accounting reports...');
    }
}

let department: Department; // 允许创建一个对抽象类型的引用
department = new Department(); // 错误: 不能创建一个抽象类的实例
department = new AccountingDepartment(); // 允许对一个抽象子类进行实例化和赋值
department.printName();
department.printMeeting();
department.generateReports(); // 错误: 方法在声明的抽象类中不存在
```

## 类&接口-继承关系

- 接口：多继承，可继承自类（继承类的方法签名和属性签名）
- 类：单继承，实现多接口

## 函数

**定义函数类型**

```
// 方式1
function add(x: number, y: number): number {
    return x + y;
}
// 方式2
let myAdd = function(x: number, y: number): number { return x + y; };
// 方式3
let myAdd: (x: number, y: number) => number =
    function(x: number, y: number): number { return x + y; };
```

**可选函数类型**

```
// 可选参数，必须在函数末尾
function buildName(firstName: string, lastName?: string) {
    if (lastName)
        return firstName + " " + lastName;
    else
        return firstName;
}
// 为参数设置默认值，等价于参数为可选参数，默认值参数不需要在函数末尾
function buildName1(firstName: string, lastName = "Smith") {
    return firstName + " " + lastName;
}
function buildName2(firstName: string, lastName: string = "Smith") {
    return firstName + " " + lastName;
}
```

**剩余函数：效果和 java 类似**

```
function buildName(firstName: string, ...restOfName: string[]) {
  return firstName + " " + restOfName.join(" ");
}

let employeeName = buildName("Joseph", "Samuel", "Lucas", "MacKinzie");
```

**重载函数：和 java 这类编译器语言有所不同**

```
class SomeClass {

  // 方法1
  public test(para: string): number;
  // 方法2
  public test(para: number, flag: boolean): number;

  // 具体实现
  public test(para: string | number, flag?: boolean): number {
    return 0;
  }
}

new SomeClass().test(1, true);
new SomeClass().test('1');
```

## 泛型

**泛型声明：和 java 类似**

```
function identity<T>(arg: T): T {
  return arg;
}

let str: string = identity('str');
let num: number = identity(0);
```

**泛型接口&泛型类：与 java 类似**

```
// 泛型接口
interface GenericIdentityInterface<T> {
  identity(arg: T): T;
}

// 泛型类
class GenericIdentityClass<V> implements GenericIdentityInterface<string> {
  prop: V;

  constructor(prop: V) {
    this.prop = prop;
  }

  getProp(): V {
    return this.prop;
  }

  identity(arg: string): string {
    return arg;
  }
}

// 使用
let interfaces: GenericIdentityInterface<string> = new GenericIdentityClass('str');
let clazz: GenericIdentityClass<string> = new GenericIdentityClass('str');
```

**泛型约束：和 java 类似**

```
interface Lengthwise {
  length: number;
}

function loggingIdentity<T extends Lengthwise>(arg: T): T {
  console.log(arg.length); // Now we know it has a .length property, so no more error
  return arg;
}
```

## 枚举

**数字枚举：和 java 类似**

```
enum Direction {
    Up = 1,// 枚举值从1开始，并向后递增
    Down,
    Left,
    Right
}
```

**字符串枚举：枚举值通过字符串来表示，更加符合语义**

```
enum Direction {
    Up = "UP",// 字符串枚举，每个枚举值都必须进行赋值
    Down = "DOWN",
    Left = "LEFT",
    Right = "RIGHT",
}
```

## 迭代器

- for..in 迭代的是对象的 键 的列表
- for..of 迭代的是对象的键对应的值 的列表

```
let list = [4, 5, 6];
// 迭代对象为键
for (let i in list) {
    console.log(i); // "0", "1", "2",
}
// 迭代对象为键对应的值
for (let i of list) {
    console.log(i); // "4", "5", "6"
}
```
