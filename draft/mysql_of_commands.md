# Mysql 命令大全
### 1. 连接mysql
键入命令

    mysql -u root -p

回车后提示你输密码.注意用户名前可以有空格也可以没有空格，但是密码前必须没有空格，否则让你重新输入密码。

如果刚安装好MYSQL，超级用户root是没有密码的，故直接回车即可进入到MYSQL中了，MYSQL的提示符是：

    mysql>

连接到远程主机上的MYSQL。假设远程主机的IP为：110.110.110.110，用户名为root,密码为abcd123。则键入以下命令：

    mysql -h110.110.110.110 -u root -p 123

退出MYSQL命令： exit （回车）

### 2. 修改密码
1. 给root加个密码ab12。进入目录mysql\bin，然后键入以下命令

        mysqladmin -u root -password ab12

注：因为开始时root没有密码，所以-p旧密码一项就可以省略了。

2. 再将root的密码改为djg345。

        mysqladmin -u root -p ab12 password djg345


### 3. 增加新用户
1. 增加一个用户test1密码为abc，让他可以在任何主机上登录，并对所有数据库有查询、插入、修改、删除的权限。首先用root用户连入MYSQL，然后键入以下命令：

        grant select,insert,update,delete on *.* to [email=test1@”%]test1@”%[/email]” Identified by “abc”;

但增加的用户是十分危险的，你想如某个人知道test1的密码，那么他就可以在internet上的任何一台电脑上登录你的mysql数据库并对你的数据可以为所欲为了，解决办法见2。

2. 增加一个用户test2密码为abc,让他只可以在localhost上登录，并可以对数据库mydb进行查询、插入、修改、删除的操作（localhost指本地主机，即MYSQL数据库所在的那台主机），这样用户即使用知道test2的密码，他也无法从internet上直接访问数据库，只能通过MYSQL主机上的web页来访问了。

        grant select,insert,update,delete on mydb.* to [email=test2@localhost]test2@localhost[/email] identified by “abc”;

如果你不想test2有密码，可以再打一个命令将密码消掉。

        grant select,insert,update,delete on mydb.* to [email=test2@localhost]test2@localhost[/email] identified by “”;

### 4. 数据库操作
1. 建立一个名为xhkdb的数据库

        mysql> create database xhkdb;

2. 创建数据库并分配用户
  1. CREATE DATABASE 数据库名;
  2. GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON 数据库名.* TO 数据库名@localhost IDENTIFIED BY '密码';
  3. SET PASSWORD FOR '数据库名'@'localhost' = OLD_PASSWORD('密码');

        >依次执行3个命令完成数据库创建。注意：中文 “密码”和“数据库”是户自己需要设置的。

3. 显示数据库
show databases （注意：最后有个s）

        mysql> show databases;

  1. 修改MYSQL的配置文件：my.ini里面修改default-character-set=gbk
  2. 代码运行时修改：
     1. Java代码：jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=gbk
     2. PHP代码：header("Content-Type:text/html;charset=gb2312");
     3. C语言代码：int mysql_set_character_set( MYSQL * mysql, char * csname)；

        >该函数用于为当前连接设置默认的字符集。字符串csname指定了1个有效的字符集名称。连接校对成为字符集的默认校对。该函数的工作方式与SET NAMES语句类似，但它还能设置mysql- > charset的值，从而影响了由mysql_real_escape_string() 设置的字符集。

4. 删除数据库
drop database <数据库名>
例如：删除名为 xhkdb的数据库

      mysql> drop database xhkdb;

  1. 删除一个已经确定存在的数据库

          mysql> drop database drop_database;
          Query OK, 0 rows affected (0.00 sec)

  2. 删除一个不确定存在的数据库

          mysql> drop database drop_database;
          ERROR 1008 (HY000): Can't drop database 'drop_database'; database doesn't exist//发生错误，不能删除'drop_database'数据库，该数据库不存在。
          mysql> drop database if exists drop_database;
          Query OK, 0 rows affected, 1 warning (0.00 sec)//产生一个警告说明此数据库不存在
          mysql> create database drop_database;
          Query OK, 1 row affected (0.00 sec)
          mysql> drop database if exists drop_database;//if exists 判断数据库是否存在，不存在也不产生错误
          Query OK, 0 rows affected (0.00 sec)

5. 连接数据库
如果xhkdb数据库存在，尝试存取它：

    mysql> use xhkdb;
    Database changed

  1. use 语句可以通告MySQL把db_name数据库作为默认（当前）数据库使用，用于后续语句。该数据库保持为默认数据库，直到语段的结尾，或者直到发布一个不同的USE语句：

          mysql> USE db1;
          mysql> SELECT COUNT(*) FROM mytable;   # selects from db1.mytable
          mysql> USE db2;
          mysql> SELECT COUNT(*) FROM mytable;   # selects from db2.mytable

  2. 使用USE语句为一个特定的当前的数据库做标记，不会阻碍您访问其它数据库中的表。下面的例子可以从db1数据库访问作者表，并从db2数据库访问编辑表：

          mysql> USE db1;
          mysql> SELECT author_name,editor_name FROM author,db2.editor
             ->WHERE author.editor_id = db2.editor.editor_id;

  3. USE语句被设立出来，用于与Sybase相兼容。
          >有些网友问到，连接以后怎么退出。其实，不用退出来，use 数据库后，使用show databases就能查询所有数据库，如果想跳到其他数据库，用
             use 其他数据库名字
          就可以了。

6. 当前选择的数据库

    mysql> select database();

MySQL中SELECT命令类似于其他编程语言里的print或者write，你可以用它来显示一个字符串、数字、数学表达式的结果等等。如何使用MySQL中SELECT命令的特殊功能？

  1. 显示MYSQL的版本

          mysql> select version();
          +-----------------------+
          | version()             |
          +-----------------------+
          | 6.0.4-alpha-community |
          +-----------------------+
          1 row in set (0.02 sec)

  2. 显示当前时间

          mysql> select now();
          +---------------------+
          | now()               |
          +---------------------+
          | 2009-09-15 22:35:32 |
          +---------------------+
          1 row in set (0.04 sec)

  3. 显示年月日

          SELECT DAYOFMONTH(CURRENT_DATE);
          +--------------------------+
          | DAYOFMONTH(CURRENT_DATE) |
          +--------------------------+
          |                       15 |
          +--------------------------+
          1 row in set (0.01 sec)

          SELECT MONTH(CURRENT_DATE);
          +---------------------+
          | MONTH(CURRENT_DATE) |
          +---------------------+
          |                   9 |
          +---------------------+
          1 row in set (0.00 sec)

          SELECT YEAR(CURRENT_DATE);
          +--------------------+
          | YEAR(CURRENT_DATE) |
          +--------------------+
          |               2009 |
          +--------------------+
          1 row in set (0.00 sec)

  4. 显示字符串

          mysql> SELECT "welecome to my blog!";
          +----------------------+
          | welecome to my blog! |
          +----------------------+
          | welecome to my blog! |
          +----------------------+
          1 row in set (0.00 sec)

  5. 当计算器用

          select ((4 * 4) / 10 ) + 25;
          +----------------------+
          | ((4 * 4) / 10 ) + 25 |
          +----------------------+
          |                26.60 |
          +----------------------+
          1 row in set (0.00 sec)

  6. 串接字符串

          select CONCAT(f_name, " ", l_name)
          AS Name
          from employee_data
          where title = 'Marketing Executive';
          +---------------+
          | Name          |
          +---------------+
          | Monica Sehgal |
          | Hal Simlai    |
          | Joseph Irvine |
          +---------------+
          3 rows in set (0.00 sec)

  >注意：这里用到CONCAT()函数，用来把字符串串接起来。另外，我们还用到以前学到的AS给结果列'CONCAT(f_name, " ", l_name)'起了个假名。

### 5. 数据表操作
#### 创建数据表

    create table <表名> ( <字段名1> <类型1> [,..<字段名n> <类型n>]);

例如，建立一个名为MyClass的表

|字段名	|数字类型	|数据宽度	|是否为空	|是否主键	|自动增加	|默认值|
| ------|		|		|		|		|		|		|
|id		|int	|4		|否		|primary key	|	auto_increment 	|	|
|name	|char	|20		|否	 	|	 	 		|					|	|
|sex	|int	|4		|否	 	|	 			|					|0	|
|degree	|double	|16		|是		|				|					|	| |


    mysql> create table MyClass(
    > id int(4) not null primary key auto_increment,
    > name char(20) not null,
    > sex int(4) not null default '0',
    > degree double(16,2));

#### 删除数据表

drop table <表名>

例如：删除表名为 MyClass 的表

    mysql> drop table MyClass;

DROP TABLE用于取消一个或多个表。您必须有每个表的DROP权限。所有的表数据和表定义会被取消，所以使用本语句要小心！

>注意：对于一个带分区的表，DROP TABLE会永久性地取消表定义，取消各分区，并取消储存在这些分区中的所有数据。DROP TABLE还会取消与被取消的表有关联的分区定义（.par）文件。

对与不存在的表，使用IF EXISTS用于防止错误发生。当使用IF EXISTS时，对于每个不存在的表，会生成一个NOTE。

RESTRICT和CASCADE可以使分区更容易。目前，RESTRICT和CASCADE不起作用。

#### 表插入数据

    insert into <表名> [( <字段名1>[,..<字段名n > ])] values ( 值1 )[, ( 值n )]

例如：往表 MyClass中插入二条记录, 这二条记录表示：编号为1的名为Tom的成绩为96.45, 编号为2 的名为Joan 的成绩为82.99， 编号为3 的名为Wang 的成绩为96.5。

   mysql> insert into MyClass values(1,'Tom',96.45),(2,'Joan',82.99), (2,'Wang', 96.59);

>注意：insert into每次只能向表中插入一条记录。

#### 查询表中的数据
1. 查询所有行
命令： select <字段1，字段2，...> from < 表名 > where < 表达式 >
例如：查看表 MyClass 中所有数据

    mysql> select * from MyClass;


2. 查询前几行数据
例如：查看表 MyClass 中前2行数据

    mysql> select * from MyClass order by id limit 0,2;

select一般配合where使用，以查询更精确更复杂的数据。

#### 删除表中数据
delete from 表名 where 表达式

例如：删除表 MyClass中编号为1 的记录

    mysql> delete from MyClass where id=1;


下面是一个删除数据前后表的对比。

|FirstName	|LastName	|Age|
| ----- | | |
|Peter		|Griffin	|35	|
|Glenn		|Quagmire	|33	|

下面以PHP代码为例删除 "Persons" 表中所有 LastName='Griffin' 的记录：

    ?php
       $con = mysql_connect("localhost","peter","abc123");
       if (!$con)
       {
          die('Could not connect: ' . mysql_error());
       }
       mysql_select_db("my_db", $con);
       mysql_query("DELETE FROM Persons WHERE LastName='Griffin'"); mysql_close($con);
    ?

在这次删除之后，表是这样的：

|FirstName	|LastName	|Age|
| ----- | | |
|Glenn		|Quagmire	|33	|

#### 修改表中数据
update 表名 set 字段=新值,… where 条件

    mysql> update MyClass set name='Mary' where id=1;

例子1：单表的MySQL UPDATE语句：

    UPDATE [LOW_PRIORITY] [IGNORE] tbl_name SET col_name1=expr1 [, col_name2=expr2 ...] [WHERE where_definition] [ORDER BY ...] [LIMIT row_count]

例子2：多表的UPDATE语句：

    UPDATE [LOW_PRIORITY] [IGNORE] table_references SET col_name1=expr1 [, col_name2=expr2 ...] [WHERE where_definition]

UPDATE语法可以用新值更新原有表行中的各列。SET子句指示要修改哪些列和要给予哪些值。WHERE子句指定应更新哪些行。如果没有WHERE子句，则更新所有的行。如果指定了ORDER BY子句，则按照被指定的顺序对行进行更新。LIMIT子句用于给定一个限值，限制可以被更新的行的数目。

1. 查询字段

    desc table_name

返回的是字段的结构

2. 增加字段

  + 命令：alter table 表名 add字段 类型 其他;
  + 例如：在表MyClass中添加了一个字段passtest，类型为int(4)，默认值为0

        mysql> alter table MyClass add passtest int(4) default '0'

3. 加索引

    mysql> alter table 表名 add index 索引名 (字段名1[，字段名2 …]);

例子：

    mysql> alter table employee add index emp_name (name);

  + 加主关键字的索引

        mysql> alter table 表名 add primary key (字段名);

  例子：

        mysql> alter table employee add primary key(id);

  + 加唯一限制条件的索引

        mysql> alter table 表名 add unique 索引名 (字段名);

  例子：

    mysql> alter table employee add unique emp_name2(cardnumber);


4. 删除某个索引

    mysql> alter table 表名 drop index 索引名;

例子：

    mysql>alter table employee drop index emp_name;

6. 修改原字段名称及类型：

    mysql> ALTER TABLE table_name CHANGE old_field_name new_field_name field_type;

#### 修改表名
命令：rename table 原表名 to 新表名;

例如：在表MyClass名字更改为YouClass

    mysql> rename table MyClass to YouClass;

当你执行 RENAME 时，你不能有任何锁定的表或活动的事务。你同样也必须有对原初表的 ALTER 和 DROP 权限，以及对新表的 CREATE 和 INSERT 权限。

如果在多表更名中，MySQL 遭遇到任何错误，它将对所有被更名的表进行倒退更名，将每件事物退回到最初状态。

RENAME TABLE 在 MySQL 3.23.23 中被加入。

### 6. 备份数据库
1. 导出整个数据库
导出文件默认是存在mysql\bin目录下

    mysqldump -u 用户名 -p 数据库名 > 导出的文件名
    mysqldump -u user_name -p123456 database_name > outfile_name.sql

2. 导出一个表

    mysqldump -u 用户名 -p 数据库名 表名> 导出的文件名
    mysqldump -u user_name -p database_name table_name > outfile_name.sql

3. 导出一个数据库结构

    mysqldump -u user_name -p -d –add-drop-table database_name > outfile_name.sql
    -d 没有数据 –add-drop-table 在每个create语句之前增加一个drop table

4. 带语言参数导出

    mysqldump -uroot -p –default-character-set=latin1 –set-charset=gbk –skip-opt database_name > outfile_name.sql

例如，将aaa库备份到文件back_aaa中：
　　
    [root@test1 root]# cd　/home/data/mysql
    [root@test1 mysql]# mysqldump -u root -p --opt aaa > back_aaa
