---
title: Android - Kotlin Ranges 源码学习
date: 2021-09-20 14:46:58
categories: 客户端
---

## 1..10 源码分析

#### 实例代码

```kotlin
fun main(args: Array<String>) {
    val i = 3
    if (i in 1..10) { // 这个就是Range表达式
    // 可以用 if (i in 1.rangeTo(10)) 来代替 
        println(i)
    }
}
```

#### 原理分析

上面 `1..10` 就表示一个Range表达式。跳转到 `..` 的源码实现为 `rangeTo`：

```kotlin
/** Creates a range from this value to the specified [other] value.*/
public operator fun rangeTo(other: Int): IntRange
```

`1..10`这个表达式是Int中实现了`rangeTO()`操作符，它等价于`1.rangTo(10)`，返回一个`IntRange(1, 10)`，Kotlin中的源码如下：

```kotlin
class Int {
    //...
    operator fun rangeTo(other: Long): LongRange = LongRange(this, other)
    //...
    operator fun rangeTo(other: Int): IntRange = IntRange(this, other)
    //...
}
```

下面将以`IntRange`为例，简单分析Range的实现和工作。下图为`IntRange`的类图：

![0b656f526d35987e0fef309bce6528fe](/image/B54C745A-A12E-49C8-A05B-AF13B4254FF4.png)

`IntRange`实现了`ClosedRange<T>`接口，该接口需要传入一个实现了`Comparable<T>`接口的范型，对于`IntRange`来说就是`Int`。

`ClosedRange<T>`就相当于上面说的闭区间，区间的两个端点分别是接口中的两个参数：`start`和`endInclusive`，最主要的是它的`contains()`函数。`start`和`endInclusive`必须要实现该接口的类去`override`，而`contains()`已经在`ClosedRange`中实现了，则不需要进行重写。这也是`Kotlin`和`Java`不同的地方之一：

接口中可以有方法实现，也可以只定义方法签名；也可以有自己的属性，但是不能对属性进行初始化，必须由实现它的类进行初始化，否则抽象类就要下岗了。

以下是该接口的源码：  

```kotlin
public interface ClosedRange<T: Comparable<T>> {
    /**
     * The minimum value in the range.
     */
    public val start: T

    /**
     * The maximum value in the range (inclusive).
     */
    public val endInclusive: T

    /**
     * Checks whether the specified [value] belongs to the range.
     */
    public operator fun contains(value: T): Boolean = value >= start && value <= endInclusive

    /**
     * Checks whether the range is empty.
     */
    public fun isEmpty(): Boolean = start > endInclusive
}
```

`IntRange`中给两个端点进行赋值，代码如下：

```kotlin
public class IntRange(start: Int, endInclusive: Int) : IntProgression(start, endInclusive, 1), ClosedRange<Int> {
    override val start: Int get() = first
    override val endInclusive: Int get() = last
    // ...
}
```

这个`first`和`last`是什么东西？点进去之后，发现是它的父类`IntProgression`中的值。

```kotlin
public open class IntProgression
    internal constructor
    (
            start: Int,
            endInclusive: Int,
            step: Int
    ) : Iterable<Int> {
    init {
        if (step == 0) throw kotlin.IllegalArgumentException("Step must be non-zero")
    }

    /**
     * The first element in the progression.
     */
    public val first: Int = start

    /**
     * The last element in the progression.
     */
    public val last: Int = getProgressionLastElement(start.toInt(), endInclusive.toInt(), step).toInt()

    /**
     * The step of the progression.
     */
    public val step: Int = step

    override fun iterator(): IntIterator = IntProgressionIterator(first, last, step)

    // ...

    companion object {
        public fun fromClosedRange(rangeStart: Int, rangeEnd: Int, step: Int): IntProgression = IntProgression(rangeStart, rangeEnd, step)
    }
}
```

`IntProgression`的作用主要有两个：

1. 确定迭代时区间中的最后一个值`last`，由于迭代时`step`可以不为`1`，这个值有可能不等于区间右边的值。例如`for(i in 1..20 step 3)`，最后一个值应该是`19`。该值通过`progressionUtil`中的函数计算得来。

2. 迭代功能的真正实现。`IntProgression`实现了`Iterable<T>`，这个接口就是用来实现迭代功能。重写接口的`iterator()`函数，返回一个迭代器，这个迭代器必须实现`Iterator<T>`。`IntPresssion`返回一个`IntProgressionIterator`的迭代器，迭代需要的`hasNext()`和`next()`真正实现就在这个类里。

```kotlin
internal class IntProgressionIterator(first: Int, last: Int, val step: Int) : IntIterator() {
     private val finalElement = last
     private var hasNext: Boolean = if (step > 0) first <= last else first >= last
     private var next = if (hasNext) first else finalElement

     override fun hasNext(): Boolean = hasNext

     override fun nextInt(): Int {
         val value = next
         if (value == finalElement) {
             if (!hasNext) throw kotlin.NoSuchElementException()
             hasNext = false
         }
         else {
             next += step
         }
         return value
     }
 }
```

```kotlin
 public abstract class IntIterator : Iterator<Int> {
     override final fun next() = nextInt()

     /** Returns the next value in the sequence without boxing. */
     public abstract fun nextInt(): Int
 }
```

```kotlin
 public interface Iterator<out T> {
     public operator fun next(): T
     public operator fun hasNext(): Boolean
 }
```

总结：`IntRange`实现的接口`ClosedRange`实现了区间功能，父类`IntProgression`实现了迭代功能。`LongRange`和`CharRange`原理和`IntRange`相同。我们只要实现了这个两个接口，就可以定义自己`range`，并对它进行迭代操作。

## 自定义 rangeTo 操作符

```kotlin
fun main() {
    val start = MyDate(2016, 11, 11)
    val end = MyDate(2016, 11, 30)
    val other = MyDate(2017, 1, 1)

    // 判断 other 是否在 start 与 end 之间
    // 操作符 .. 调用了 rangeTo，然后 间接调用了 compareTo 函数
    println(other in start..end)

    // 打印出 start 与 end 区间内的所有值
    // 操作符 .. 调用了 rangeTo，然后 间接调用了 iterator
    for (date in start..end) {
        println(date)
    }
}

data class MyDate(val year: Int, val month: Int, val dayOfMonth: Int) : Comparable<MyDate> {

    override operator fun compareTo(other: MyDate): Int {
        return if (year != other.year) {
            year - other.year
        } else if (month != other.month) {
            month - other.month
        } else {
            dayOfMonth - other.dayOfMonth
        }
    }

    operator fun rangeTo(other: MyDate): DateRange {
        return DateRange(this, other)
    }

    fun addOneDay(): MyDate {
        val c = Calendar.getInstance()
        c.set(this.year, this.month, this.dayOfMonth)
        c.add(Calendar.DAY_OF_MONTH, 1)
        return MyDate(c.get(Calendar.YEAR), c.get(Calendar.MONTH), c.get(Calendar.DAY_OF_MONTH))
    }

    class DateRange(override val start: MyDate, override val endInclusive: MyDate) : Iterable<MyDate>, ClosedRange<MyDate> {

        override fun iterator(): Iterator<MyDate> = object : Iterator<MyDate> {
            var hasNext = start <= endInclusive
            var next = if (hasNext) start else endInclusive
            override fun hasNext(): Boolean = hasNext
            override fun next(): MyDate {
                val result = next
                next = next.addOneDay()
                hasNext = next <= endInclusive
                return result
            }
        }
    }
}
```

## 参考

https://juejin.cn/post/6844903516969041927
https://www.jianshu.com/p/ca44b812a942

