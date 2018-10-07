---
title: Effective Java 同步
date: 2018-10-03 20:01:02
categories: 客户端
---

## 同步访问共享的可变数据

当多线程共享可变数据时，每个读或者写数据的线程都必须执行同步。同步方式可以是加锁，也可以是volatile。如果没有同步，就无法确保一个线程所做的修改可以被另一个线程获知。

## 避免过度同步

- 在设计一个可变类的时候，要考虑一下它们是否应该自己完成同步操作。过度的帮助类进行同步操作，会带来性能上的损耗
- 为了避免不可控性，千万不要在同步区域中调用外来方法。要把同步操作的控制权牢牢抓在自己手中

	> ```java
public interface SetObserver {
    void added(ObservableSet set, Object element);
}

public static class ObservableSet {

    private final List<SetObserver> observers
                        = new ArrayList<SetObserver>();

    public void addObserver(SetObserver observer) {
        synchronized (observers) {
            observers.add(observer);
        }
    }

    // 错误通知示范：
    // 如果在SetObserver的added()方法中调用复杂的addObserver()方法，
    // 会导致ConcurrentModificationException异常，相当于外部调用方法
    // 来影响同步代码块中的操作逻辑
    private void notifyElementAdded(Object element) {
        synchronized (observers) {
            for (SetObserver observer : observers)
                observer.added(this, element);
        }
    }

    // 正确通知示范：
    // 将外来调用方法放到同步块外面，同步块中只做极少的事情
    private void notifyElementAdded(Object element) {
        List<SetObserver> tempObservers;
        synchronized (observers) {
            tempObservers = new ArrayList(observers);
        }
        for (SetObserver observer : tempObservers)
            observer.added(this, element);
    }

    @Override
    public boolean add(Object element) {
        // 添加数据步骤省略
        // 通知所有观察者对象
        if (added)
            notifyElementAdded(element);
        return added;
    }
}
	```
	
## executor和task优先于线程

Executor Framework提供了灵活的任务执行工具，支持各种类型的线程池。引导开发者将线程工作拆分成了独立任务单元(Runnable)。因此，推荐开发者使用Executor解决问题，而不是自己创建线程。

## 慎用延迟初始化

- 大多数域应该正常地进行初始化，而不是延迟初始化。延迟初始化会带来同步问题，产生不必要的错误
- 某些场景必须要使用延迟初始化，有如下建议：

	>```java
	// 对于静态作用域，建议使用Class Holder初始化模式
	private static class FieldHolder {
		static final FieldType field = computeFieldValue();
	}
	static FieldType getField(){
		return FieldHolder.field;
	}
	// 对于实例域，则建议使用双重检查模式
	private volatile FieldType field;
	FieldValue getField() {
		FieldType result = field;
		if (result == null) {
			synchronized(this){
			    result = field;
				if (result == null)
				    field = result = computeFieldValue();
			}
		}
		return result;
	}
	// 对于可以接受重复初始化的实例域，则考虑使用单重检测模式
	private volatile FieldType field;
	private FieldType getField(){
		FieldType result = field;
		if (result == null) {
			field = result = computeFieldValue();
		}
		return result;
	}
	```
	
## 不要依赖于线程调度器

任何依赖于线程调度器来达到正确性或者性能要求的程序，很有可能都是不可移殖的。