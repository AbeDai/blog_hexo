---
title: 数据库-MySql操作大全
date: 2019-01-24 19:58:22
tags: 基础
---

## 数据类型介绍

### 数值类型

| 类型 | 大小 | 范围 | 详情 |
| ----- | ----- | ----- | ----- |
| TINYINT |	1 字节 | 有符号:(-128，127) </br>无符号:(0，255) |	极小整数值 |
| SMALLINT | 2 字节 | 有符号:(-32 768，32 767) </br>无符号:(0，65 535) | 小整数值 |
| MEDIUMINT | 3 字节 | 有符号:(-8 388 608，8 388 607) </br>无符号:(0，16 777 215) | 中等整数值 |
| INT或INTEGER | 4 字节 | 有符号:(-2 147 483 648，2 147 483 647) </br>无符号:(0，4 294 967 295) | 大整数值 | 
| BIGINT | 8 字节 | 有符号:(-9,223,372,036,854,775,808，9 223 372 036 854 775 807) </br>无符号:(0，18 446 744 073 709 551 615) | 极大整数值| 
| FLOAT | 4 字节 | 有符号:(-3.402 823 466 E+38，-1.175 494 351 E-38)，0，(1.175 494 351 E-38，3.402 823 466 351 E+38) </br>无符号:0，(1.175 494 351 E-38，3.402 823 466 E+38) | 单精度浮点数值 | 
| DOUBLE | 8 字节 | 有符号:(-1.797 693 134 862 315 7 E+308，-2.225 073 858 507 201 4 E-308)，0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308) </br>无符号:0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308) | 双精度浮点数值 |
| DECIMAL | 对DECIMAL(M,D) ，如果M>D，为M+2否则为D+2 | 依赖于M和D的值 | 小数值 |

### 日期和时间类型

| 类型 | 大小 | 范围 | 格式 | 详情 |
| ----- | ----- | ----- | ----- | ----- |
| DATE | 3字节 | 1000-01-01 到 9999-12-31 | YYYY-MM-DD | 日期值 |
| TIME | 3字节 | -838:59:59 到 838:59:59 | HH:MM:SS | 时间值或持续时间 |
| YEAR | 1字节 | 1901 到 2155 | YYYY | 年份值
| DATETIME | 8字节 | 1000-01-01 00:00:00 到 9999-12-31 23:59:59 | YYYY-MM-DD HH:MM:SS | 混合日期和时间值 |
| TIMESTAMP | 4字节 | 1970-01-01 00:00:00 到 2038年1月19日 凌晨 03:14:07（格林尼治时间）   | YYYYMMDD HHMMSS | 混合日期和时间值，时间戳 |


### 字符串类型

| 类型 | 大小 | 详情 |
| ----- | ----- | ----- |
| CHAR | 0 到 255B | 定长字符串 |
| VARCHAR | 0 到 64K | 变长字符串 |
| TINYBLOB | 0 到 255B | 不超过 255 个字符的二进制字符串 |
| TINYTEXT | 0 到 255B | 短文本字符串 |
| BLOB | 0 到 64K | 二进制形式的长文本数据 |
| TEXT | 0 到 64K | 长文本数据 |
| MEDIUMBLOB | 0 到 16K | 二进制形式的中等长度文本数据 |
| MEDIUMTEXT | 0 到 16K | 中等长度文本数据 |
| LONGBLOB | 0 到 4GB | 二进制形式的极大文本数据 |
| LONGTEXT | 0 到 4GB | 极大文本数据 |


## 连接数据库

```sql
-- 连接到数据库
mysql -uroot -ppassword -hlocalhost -P3306;
```

## 切换数据库操作

```sql
-- 查看数据库
show databases;
+--------------------+
| Database           |
+--------------------+
| daiyibo_test       |
| information_schema |
| mysql              |
| pakun              |
| performance_schema |
| sys                |
+--------------------+

-- 使用数据库
use database;
Database changed
```

## 表单操作

```sql
-- 显示表单
show tables;
+------------------------+
| Tables_in_daiyibo_test |
+------------------------+
| test_1                 |
| test_2                 |
+------------------------+

-- 显示表单列信息
show columns from tablename;
describe tablename;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| name  | varchar(19) | YES  |     | NULL    |       |
| id    | int(11)     | NO   | PRI | NULL    |       |
| value | varchar(10) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
```

## 查找操作

```sql
-- 查找所有信息
select * from products;
+---------+---------+----------------+------------+----------------------------------------------------------------+
| prod_id | vend_id | prod_name      | prod_price | prod_desc                                                      |
+---------+---------+----------------+------------+----------------------------------------------------------------+
| ANV01   |    1001 | .5 ton anvil   |       5.99 | .5 ton anvil, black, complete with handy hook                  |
| ANV02   |    1001 | 1 ton anvil    |       9.99 | 1 ton anvil, black, complete with handy hook and carrying case |
| ANV03   |    1001 | 2 ton anvil    |      14.99 | 2 ton anvil, black, complete with handy hook and carrying case |
| DTNTR   |    1003 | Detonator      |      13.00 | Detonator (plunger powered), fuses not included                |
| FB      |    1003 | Bird seed      |      10.00 | Large bag (suitable for road runners)                          |
| FC      |    1003 | Carrots        |       2.50 | Carrots (rabbit hunting season only)                           |
| FU1     |    1002 | Fuses          |       3.42 | 1 dozen, extra long                                            |
| JP1000  |    1005 | JetPack 1000   |      35.00 | JetPack 1000, intended for single use                          |
| JP2000  |    1005 | JetPack 2000   |      55.00 | JetPack 2000, multi-use                                        |
| OL1     |    1002 | Oil can        |       8.99 | Oil can, red                                                   |
| SAFE    |    1003 | Safe           |      50.00 | Safe with combination lock                                     |
| SLING   |    1003 | Sling          |       4.49 | Sling, one size fits all                                       |
| TNT1    |    1003 | TNT (1 stick)  |       2.50 | TNT, red, single stick                                         |
| TNT2    |    1003 | TNT (5 sticks) |      10.00 | TNT, red, pack of 10 sticks                                    |
+---------+---------+----------------+------------+----------------------------------------------------------------+

-- 查找指定列信息
select vend_id, prod_name from products;
+---------+----------------+
| vend_id | prod_name      |
+---------+----------------+
|    1001 | .5 ton anvil   |
|    1001 | 1 ton anvil    |
|    1001 | 2 ton anvil    |
|    1003 | Detonator      |
|    1003 | Bird seed      |
|    1003 | Carrots        |
|    1002 | Fuses          |
|    1005 | JetPack 1000   |
|    1005 | JetPack 2000   |
|    1002 | Oil can        |
|    1003 | Safe           |
|    1003 | Sling          |
|    1003 | TNT (1 stick)  |
|    1003 | TNT (5 sticks) |
+---------+----------------+

-- 查找去重后的指定列信息
select distinct vend_id from products;
+---------+
| vend_id |
+---------+
|    1001 |
|    1002 |
|    1003 |
|    1005 |
+---------+
```

### SELECT子句顺序

```sql
顺序：1      2              3                 4              5                  6              7
select * from tablename where value1 > 0 group by value2 having value3 > 0 order by value4 limit 1;
```

### 控制行数

```sql
-- 查找信息后指定检索行数
select prod_name from products limit 5;
+--------------+
| prod_name    |
+--------------+
| .5 ton anvil |
| 1 ton anvil  |
| 2 ton anvil  |
| Detonator    |
| Bird seed    |
+--------------+

-- 查找信息后指定检索的开始行和行数
select prod_name from products limit 1, 5;
+-------------+
| prod_name   |
+-------------+
| 1 ton anvil |
| 2 ton anvil |
| Detonator   |
| Bird seed   |
| Carrots     |
+-------------+
```

### 排序操作
```sql
-- 查找数据后进行排序
select vend_id, prod_name, prod_price from products order by vend_id, prod_name desc, prod_price desc;
+---------+----------------+------------+
| vend_id | prod_name      | prod_price |
+---------+----------------+------------+
|    1001 | 2 ton anvil    |      14.99 |
|    1001 | 1 ton anvil    |       9.99 |
|    1001 | .5 ton anvil   |       5.99 |
|    1002 | Oil can        |       8.99 |
|    1002 | Fuses          |       3.42 |
|    1003 | TNT (5 sticks) |      10.00 |
|    1003 | TNT (1 stick)  |       2.50 |
|    1003 | Sling          |       4.49 |
|    1003 | Safe           |      50.00 |
|    1003 | Detonator      |      13.00 |
|    1003 | Carrots        |       2.50 |
|    1003 | Bird seed      |      10.00 |
|    1005 | JetPack 2000   |      55.00 |
|    1005 | JetPack 1000   |      35.00 |
+---------+----------------+------------+
```

### 过滤操作
将查找后的数据，进行过滤操作。
> 过滤操作的操作符如下：
> =，<>，!=， <， <=， >， >=， between and，is null

```sql
-- 过滤数据，普通操作符示例
select prod_name, prod_price from products where prod_name = "fuses";
+-----------+------------+
| prod_name | prod_price |
+-----------+------------+
| Fuses     |       3.42 |
+-----------+------------+

-- 过滤数据，between操作符示例
select prod_name, prod_price from products where prod_price between 10 and 14;
+----------------+------------+
| prod_name      | prod_price |
+----------------+------------+
| Bird seed      |      10.00 |
| TNT (5 sticks) |      10.00 |
| Detonator      |      13.00 |
+----------------+------------+

-- 过滤数据，is null操作符示例
select cust_email from customers where cust_email is null;
+------------+
| cust_email |
+------------+
| NULL       |
| NULL       |
+------------+
```

### 多条件过滤操作符
将多个条件操作符组合起来，进行多条件过滤操作。
- AND：就是条件“且”的意思
- OR：就是条件“或”的意思

```sql
-- 过滤数据，or 操作符示例
select prod_name, prod_price from products where vend_id=1002 or vend_id=1003;
+----------------+------------+
| prod_name      | prod_price |
+----------------+------------+
| Fuses          |       3.42 |
| Oil can        |       8.99 |
| Detonator      |      13.00 |
| Bird seed      |      10.00 |
| Carrots        |       2.50 |
| Safe           |      50.00 |
| Sling          |       4.49 |
| TNT (1 stick)  |       2.50 |
| TNT (5 sticks) |      10.00 |
+----------------+------------+

-- 过滤数据，and 操作符示例
select prod_name, prod_price from products where vend_id=1002 and prod_price > 4;
+-----------+------------+
| prod_name | prod_price |
+-----------+------------+
| Oil can   |       8.99 |
+-----------+------------+

-- 过滤数据，or、and 操作符混合使用示例
select prod_name, prod_price from products where (vend_id=1002 or vend_id=1003) and prod_price > 4;
+----------------+------------+
| prod_name      | prod_price |
+----------------+------------+
| Oil can        |       8.99 |
| Detonator      |      13.00 |
| Bird seed      |      10.00 |
| Safe           |      50.00 |
| Sling          |       4.49 |
| TNT (5 sticks) |      10.00 |
+----------------+------------+

-- 过滤数据，in 表示只要允许其中()中的其中一个条件，操作符使用示例
select prod_name, prod_price, vend_id from products where vend_id in (1002, 1003);
+----------------+------------+---------+
| prod_name      | prod_price | vend_id |
+----------------+------------+---------+
| Fuses          |       3.42 |    1002 |
| Oil can        |       8.99 |    1002 |
| Detonator      |      13.00 |    1003 |
| Bird seed      |      10.00 |    1003 |
| Carrots        |       2.50 |    1003 |
| Safe           |      50.00 |    1003 |
| Sling          |       4.49 |    1003 |
| TNT (1 stick)  |       2.50 |    1003 |
| TNT (5 sticks) |      10.00 |    1003 |
+----------------+------------+---------+

-- 过滤数据，not 表示对前面操作取反，使用示例
select prod_name, prod_price, vend_id from products where vend_id not in (1002, 1003);
+--------------+------------+---------+
| prod_name    | prod_price | vend_id |
+--------------+------------+---------+
| .5 ton anvil |       5.99 |    1001 |
| 1 ton anvil  |       9.99 |    1001 |
| 2 ton anvil  |      14.99 |    1001 |
| JetPack 1000 |      35.00 |    1005 |
| JetPack 2000 |      55.00 |    1005 |
+--------------+------------+---------+
```

### 通配符过滤
通配符过滤操作，有点类似于模糊过滤操作。下面主要介绍%和_两个操作符。

- “%” 操作符，表示匹配出现任何次数的任意字符。
- “_” 操作符，表示匹配任何出现的单个字符。

```sql
-- “%” 操作符使用介绍
select prod_id, prod_name from products where prod_name like "%anvil";
+---------+--------------+
| prod_id | prod_name    |
+---------+--------------+
| ANV01   | .5 ton anvil |
| ANV02   | 1 ton anvil  |
| ANV03   | 2 ton anvil  |
+---------+--------------+

-- “_” 操作符使用介绍
select cust_contact, cust_id from customers where cust_contact like "___am";
+--------------+---------+
| cust_contact | cust_id |
+--------------+---------+
| Y Sam        |   10004 |
+--------------+---------+
```

### 正则表达式过滤
mysql支持正则表达式。若要使用正则表达式，则用regexp作为操作符。

```sql
select * from customers where cust_address regexp "^2.";
+---------+-------------+----------------+-----------+------------+----------+--------------+--------------+-----------------+
| cust_id | cust_name   | cust_address   | cust_city | cust_state | cust_zip | cust_country | cust_contact | cust_email      |
+---------+-------------+----------------+-----------+------------+----------+--------------+--------------+-----------------+
|   10001 | Coyote Inc. | 200 Maple Lane | Detroit   | MI         | 44444    | USA          | Y Lee        | ylee@coyote.com |
+---------+-------------+----------------+-----------+------------+----------+--------------+--------------+-----------------+
```

### 拼接字段
可以通过concat方法对字段内容进行拼接操作。
```sql
select concat(vend_name, '(', vend_country, ')') from vendors order by vend_name;
+-------------------------------------------+
| concat(vend_name, '(', vend_country, ')') |
+-------------------------------------------+
| ACME(USA)                                 |
| Anvils R Us(USA)                          |
| Furball Inc.(USA)                         |
| Jet Set(England)                          |
| Jouets Et Ours(France)                    |
| LT Supplies(USA)                          |
+-------------------------------------------+
```

### 使用别名
别名是一个字段或值的替代名。通过as关键字赋予别名。如果使用了别名，相当于可以对字段进行重新命名。
```sql
select concat(vend_name, '(', vend_country, ')') as vend_title from vendors order by vend_name;
+------------------------+
| vend_title             |
+------------------------+
| ACME(USA)              |
| Anvils R Us(USA)       |
| Furball Inc.(USA)      |
| Jet Set(England)       |
| Jouets Et Ours(France) |
| LT Supplies(USA)       |
+------------------------+
```

### 使用算数计算
可以通过算数运算符对字段进行运算操作。支持的操作符有+，-，*，/。
```sql
select prod_id, quantity, item_price, quantity*item_price as expanded_price from orderitems where order_num = 20005;
+---------+----------+------------+----------------+
| prod_id | quantity | item_price | expanded_price |
+---------+----------+------------+----------------+
| ANV01   |       10 |       5.99 |          59.90 |
| ANV02   |        3 |       9.99 |          29.97 |
| TNT2    |        5 |      10.00 |          50.00 |
| FB      |        1 |      10.00 |          10.00 |
+---------+----------+------------+----------------+
```

### 文本处理内置函数
-  Left()： 返回串左边的字符
-  Length()：返回串的长度
-  Locate()：找出串的一个子串
-  Lower()：将串转换为小写
-  LTrim()：去掉串左边的空格
-  Right()：返回串右边的字符
-  RTrim()：去掉串右边的空格
-  Soundex()：返回串的SOUNDEX值
-  SubString()：返回子串的字符
-  Upper()：将串转换为大写

```sql
select upper(prod_name) from products;
+------------------+
| upper(prod_name) |
+------------------+
| .5 TON ANVIL     |
| 1 TON ANVIL      |
| 2 TON ANVIL      |
| DETONATOR        |
| BIRD SEED        |
| CARROTS          |
| FUSES            |
| JETPACK 1000     |
| JETPACK 2000     |
| OIL CAN          |
| SAFE             |
| SLING            |
| TNT (1 STICK)    |
| TNT (5 STICKS)   |
+------------------+
```

### 时间处理内置函数
- AddDate()：增加一个日期(天、周等)
- AddTime()：增加一个时间(时、分等)
- CurDate()：返回当前日期
- CurTime()：返回当前时间
- Date()：返回日期时间的日期部分 
- DateDiff()：计算两个日期之差
- Date_Add()：高度灵活的日期运算函数
- Date_Format()：返回一个格式化的日期或时间串
- Day()：返回一个日期的天数部分
- DayOfWeek()：对于一个日期，返回对应的星期几
- Hour()：返回一个时间的小时部分 
- Minute()：返回一个时间的分钟部分
- Month()：返回一个日期的月份部分
- Now()：返回当前日期和时间
- Second()：返回一个时间的秒部分
- Time()：返回一个日期时间的时间部分
- Year()：返回一个日期的年份部分

```sql
-- month显示操作
select month(order_date) as month from orders;
+-------+
| month |
+-------+
|     9 |
|     9 |
|     9 |
|    10 |
|    10 |
+-------+

-- month比较操作
select month(order_date) as month from orders where month(order_date)>9;
+-------+
| month |
+-------+
|    10 |
|    10 |
+-------+
```

### 数值处理函数
- Abs()：返回一个数的绝对值
- Cos()：返回一个角度的余弦
- Exp()：返回一个数的指数值 
- Mod()：返回除操作的余数
- Pi()：返回圆周率
- Rand()：返回一个随机数
- Sin()：返回一个角度的正弦
- Sqrt()：返回一个数的平方根
- Tan()：返回一个角度的正切

```sql
select abs(-1);
+---------+
| abs(-1) |
+---------+
|       1 |
+---------+
```

### 汇总数据
- AVG()：返回某列的平均值 
- COUNT()：返回某列的行数
- MAX()：返回某列的最大值
- MIN()：返回某列的最小值
- SUM()：返回某列值之和

```sql
-- 汇总操作
select avg(prod_price) from products;
+-----------------+
| avg(prod_price) |
+-----------------+
|       16.133571 |
+-----------------+

-- 复杂汇总操作
select count(*) as num_items, min(prod_price) as price_min, max(prod_price) as price_max, avg(prod_price) as price_avg from products;
+-----------+-----------+-----------+-----------+
| num_items | price_min | price_max | price_avg |
+-----------+-----------+-----------+-----------+
|        14 |      2.50 |     55.00 | 16.133571 |
+-----------+-----------+-----------+-----------+
```

### 分组数据
MySQL允许对数据进行分组操作，分组允许把数据分为多个逻辑组，以便能对每个组进行聚集计算。
- “group by” 操作符，提供了对数据进行分组的能力。
- “having” 操作符，提供了对分组数据进行过滤的能力。用法和“where”操作符无异，只是“where”操作对象为所有数据，“having”操作对象为分组后的数据。

```sql
-- 分组查找数据
select vend_id, count(*) as num_prods from products group by vend_id;
+---------+-----------+
| vend_id | num_prods |
+---------+-----------+
|    1001 |         3 |
|    1002 |         2 |
|    1003 |         7 |
|    1005 |         2 |
+---------+-----------+
-- 对分组查找的数据进行过滤操作
select vend_id, count(*) as num_prods from products group by vend_id having count(*)>=2;
+---------+-----------+
| vend_id | num_prods |
+---------+-----------+
|    1001 |         3 |
|    1002 |         2 |
|    1003 |         7 |
|    1005 |         2 |
+---------+-----------+
```

### 子句查询
mysql支持子查询，就是将嵌套使用select操作。在复杂的数据库操作中，是非常有用的。

```sql
-- 利用子查询进行过滤
select cust_name,  cust_contact from customers where cust_id in (
    select cust_id from orders where order_num in (
        select order_num from orderitems where prod_id='TNT2'));
+----------------+--------------+
| cust_name      | cust_contact |
+----------------+--------------+
| Coyote Inc.    | Y Lee        |
| Yosemite Place | Y Sam        |
+----------------+--------------+

-- 作为计算字段利用子查询
select cust_name, cust_state, (
    select count(*) from orders where orders.cust_id=customers.cust_id) as order_count
    from customers order by cust_name;
+----------------+------------+-------------+
| cust_name      | cust_state | order_count |
+----------------+------------+-------------+
| Coyote Inc.    | MI         |           2 |
| E Fudd         | IL         |           1 |
| Mouse House    | OH         |           0 |
| Wascals        | IN         |           1 |
| Yosemite Place | AZ         |           1 |
+----------------+------------+-------------+
```

### 联结表
关系型数据库，会将数据组合成多个关系表的形式。此时，如果想要一次性查找多个表中的数据，就需要用到联结。联结操作有如下几种形式：

- 内部联结：此联结操作只展示相关联的行。将两个表之间的数据，通过联结操作将关联的数据过滤出来，并展示出来。
- 外部联结：此联结操作除了展示相关联的行以外，还会展示没有关联的那些行。将两个表之间的数据，通过联结操作将不相关的数据排除在外，并展示保留下来的数据。
- 多表联结：算是内部联结的一种，但他指的是多个表之间的联结操作。
- 自联结：算是内部联结的一种，但他指的是单个表自己对自己的联结操作。

```sql
-- 内部联结，下面两个sql语句等价
select customers.cust_id, orders.* from customers inner join orders on customers.cust_id=orders.cust_id;
select customers.cust_id, orders.* from customers, orders where customers.cust_id=orders.cust_id;
+---------+-----------+---------------------+---------+
| cust_id | order_num | order_date          | cust_id |
+---------+-----------+---------------------+---------+
|   10001 |     20005 | 2005-09-01 00:00:00 |   10001 |
|   10003 |     20006 | 2005-09-12 00:00:00 |   10003 |
|   10004 |     20007 | 2005-09-30 00:00:00 |   10004 |
|   10005 |     20008 | 2005-10-03 00:00:00 |   10005 |
|   10001 |     20009 | 2005-10-08 00:00:00 |   10001 |
+---------+-----------+---------------------+---------+

-- 外部级联
select customers.cust_id, orders.* from customers left outer join orders on customers.cust_id=orders.cust_id;
+---------+-----------+---------------------+---------+
| cust_id | order_num | order_date          | cust_id |
+---------+-----------+---------------------+---------+
|   10001 |     20005 | 2005-09-01 00:00:00 |   10001 |
|   10001 |     20009 | 2005-10-08 00:00:00 |   10001 |
|   10002 |      NULL | NULL                |    NULL |
|   10003 |     20006 | 2005-09-12 00:00:00 |   10003 |
|   10004 |     20007 | 2005-09-30 00:00:00 |   10004 |
|   10005 |     20008 | 2005-10-03 00:00:00 |   10005 |
+---------+-----------+---------------------+---------+

-- 多表联结
select prod_name, vend_name, prod_price, quantity from orderitems, products, vendors where products.vend_id = vendors.vend_id and orderitems.prod_id=products.prod_id and order_num=20005;
+----------------+-------------+------------+----------+
| prod_name      | vend_name   | prod_price | quantity |
+----------------+-------------+------------+----------+
| .5 ton anvil   | Anvils R Us |       5.99 |       10 |
| 1 ton anvil    | Anvils R Us |       9.99 |        3 |
| TNT (5 sticks) | ACME        |      10.00 |        5 |
| Bird seed      | ACME        |      10.00 |        1 |
+----------------+-------------+------------+----------+

-- 自联结
select p2.* from products as p1, products as p2 where p1.vend_id=p2.vend_id and p1.prod_id='DTNTR';
+---------+---------+-----------+------------+-------------------------------------------------+
| prod_id | vend_id | prod_name | prod_price | prod_desc                                       |
+---------+---------+-----------+------------+-------------------------------------------------+
| DTNTR   |    1003 | Detonator |      13.00 | Detonator (plunger powered), fuses not included |
| DTNTR   |    1003 | Detonator |      13.00 | Detonator (plunger powered), fuses not included |
| DTNTR   |    1003 | Detonator |      13.00 | Detonator (plunger powered), fuses not included |
| DTNTR   |    1003 | Detonator |      13.00 | Detonator (plunger powered), fuses not included |
| DTNTR   |    1003 | Detonator |      13.00 | Detonator (plunger powered), fuses not included |
| DTNTR   |    1003 | Detonator |      13.00 | Detonator (plunger powered), fuses not included |
| DTNTR   |    1003 | Detonator |      13.00 | Detonator (plunger powered), fuses not included |
+---------+---------+-----------+------------+-------------------------------------------------+
```

### 组合查询
组合查询通过union或union all关键字将多个查询条件组合起来。使用组合查询的规则如下：

- 每条select语句之间，必须通过union隔离
- 每条select语句，必须包含相同的列数
- union all，表示合并多条select语句的查询结果，但不对重复数据做额外处理
- union，表示合并多条select语句的查询结果，并对重复数据去重

```sql
-- union组合操作
select vend_id, prod_id, prod_price from products where prod_price <= 5 union select vend_id,prod_id, prod_price from products where vend_id=1001 or vend_id=1002 order by vend_id;
+---------+---------+------------+
| vend_id | prod_id | prod_price |
+---------+---------+------------+
|    1001 | ANV01   |       5.99 |
|    1001 | ANV02   |       9.99 |
|    1001 | ANV03   |      14.99 |
|    1002 | FU1     |       3.42 |
|    1002 | OL1     |       8.99 |
|    1003 | FC      |       2.50 |
|    1003 | SLING   |       4.49 |
|    1003 | TNT1    |       2.50 |
+---------+---------+------------+

-- union all 组合操作
select vend_id, prod_id, prod_price from products where prod_price <= 5 union all select vend_id,prod_id, prod_price from products where vend_id=1001 or vend_id=1002 order by vend_id;
+---------+---------+------------+
| vend_id | prod_id | prod_price |
+---------+---------+------------+
|    1001 | ANV01   |       5.99 |
|    1001 | ANV02   |       9.99 |
|    1001 | ANV03   |      14.99 |
|    1002 | FU1     |       3.42 |
|    1002 | OL1     |       8.99 |
|    1003 | FC      |       2.50 |
|    1003 | SLING   |       4.49 |
|    1003 | TNT1    |       2.50 |
+---------+---------+------------+
```

## 插入数据
插入数据，分为插入完整的行，插入部分的行，插入多行，插入查询结果。

```sql
-- 插入完整行
insert into customers values(null, 'Pep E. Lapew', '100 Main Street', 'Los angeles', 'CA', '90046', 'USA', null, null);

-- 插入部分行
insert into customers(cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country) values('Pep E. LaPew', '100 Main Street', 'Los Angeles', 'CA', '90090');

-- 插入多行
insert into customers(cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country) values('Pep E. LaPew', '100 Main Street', 'Los Angeles', 'CA', '90090'), ('Pep E. LaPew', '100 Main Street', 'Los Angeles', 'CA', '90091');

-- 插入查询结果
insert into customers_new(cust_id, cust_name, cust_address) select customers.cust_id, customers.cust_name, customers.cust_address from customers;
```

## 更新数据
更新数据操作，很简单，直接上代码。

```sql
-- 更新单行数据
update customers set cust_email='elmer@fudd.com' where cust_id=10005;

-- 更新多行数据
update customers set cust_email='elmer@fudd.com', cust_name='The Fudds' where cust_id=10005;
```

## 删除数据
删除数据操作，很简单，直接上代码。

```sql
-- 删除数据
delete from customers where cust_id=10005;
```

## 表操作

#### 创建表
使用create table来创建customers表单。在创建表单时，可以使用null，primary key，auto_increment，default关键字来对字段进行修饰操作。

- null：指定列是否允许null值，not null表示该列不允许存在null值。
- primary key：指定表单的主键。
- foreign key：指定外键。
- auto_increment：指定主键是否自增。
- default：指定字段的默认值。

``` sql
-- 创建表
create table customers (
    cust_id      int      not null auto_increment,
    cust_name    char(50) not null,
    cust_address char(50) null,
    cust_city    char(50) null,
    cust_state   char(5)  null,
    cust_zip     char(10) null,
    cust_country char(50) null,
    cust_contact char(50) null,
    cust_email   char(50) null,
    test_fk      int      not null,
    primary key (cust_id)
    foreign key (test_fk) REFERENCES TestTable(test_fk)
) engine=InnoDB;
```

#### 删除表
```sql
-- 删除表操作
drop table customers;
```

#### 重命名表
```sql
-- 重命名表操作
rename table customers2 to customers;
```

#### 更新字段
``` sql
-- 添加字段
alter table customers add new_id INT;
-- 删除字段
alter table customers drop new_id;
-- 修改字段（将类型调整为char(10)）
alter table customers modify new_id char(10) 
-- 修改字段（将字段名new_id改为new_id_2，将类型调整为INT）
alter table customers change new_id new_id_2 int;
```

#### 设置外键
```sql
-- 添加外键
alter table Orders add foreign key(fk_id) references TestTable(primary_id);
-- 删除外键
alter table Orders drop foreign key fk_id;
```

## 事务简介
在 MySQL 中只有使用了 Innodb 数据库引擎的数据库或表才支持事务。关键字介绍：

- begin：显式地开启一个事务
- commit：也可以使用commit work，不过二者是等价的。commit会提交事务，并使已对数据库进行的所有修改成为永久性的
- rollback：有可以使用rollback work，不过二者是等价的。回滚会结束用户的事务，并撤销正在进行的所有未提交的修改
- savepoint identifier：savepoint允许在事务中创建一个保存点，一个事务中可以有多个savepoint
- rollback to identifier：把事务回滚到标记点

```sql
-- 创建测试表
CREATE TABLE runoob_transaction_test( id int(5)) engine=innodb;
select * from runoob_transaction_test;

-- commit事务示例
begin;
insert into runoob_transaction_test value(5);
insert into runoob_transaction_test value(6);
commit;
select * from runoob_transaction_test;

-- rollback事务示例
begin;
insert into runoob_transaction_test values(7);
rollback;
select * from runoob_transaction_test;
```

## 实验数据
[Mysql必知必会-实现数据](http://www.forta.com/books/0672327120/mysql_scripts.zip)

