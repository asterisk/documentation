---
title: PostgreSQL CDR Backend
pageid: 5242923
---

If you want to go directly to postgresql database, and have the cdr_pgsql.so compiled you can use the following sample setup. On Debian, before compiling asterisk, just install libpqxx-dev. Other distros will likely have a similiar package.   

Once you have the compile done, copy the sample cdr_pgsql.conf file or create your own. 


Here is a sample:


/etc/asterisk/cdr_pgsql.conf

```

; Sample Asterisk config file for CDR logging to PostgresSQL
[global]
hostname=localhost 
port=5432 
dbname=asterisk 
password=password 
user=postgres 
table=cdr

```

Now create a table in postgresql for your cdrs

```

CREATE TABLE cdr ( 
 calldate timestamp NOT NULL , 
 clid varchar (80) NOT NULL , 
 src varchar (80) NOT NULL , 
 dst varchar (80) NOT NULL , 
 dcontext varchar (80) NOT NULL , 
 channel varchar (80) NOT NULL , 
 dstchannel varchar (80) NOT NULL , 
 lastapp varchar (80) NOT NULL , 
 lastdata varchar (80) NOT NULL , 
 duration int NOT NULL , 
 billsec int NOT NULL , 
 disposition varchar (45) NOT NULL , 
 amaflags int NOT NULL , 
 accountcode varchar (20) NOT NULL , 
 uniqueid varchar (150) NOT NULL , 
 userfield varchar (255) NOT NULL 
);

```

##### In 1.8 and later


The following columns can also be defined:

```

 peeraccount varchar(20) NOT NULL
 linkedid varchar(150) NOT NULL
 sequence int NOT NULL

```

