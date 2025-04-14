---
title: PostgreSQL CEL Backend
pageid: 5242956
---

If you want to go directly to postgresql database, and have the cel_pgsql.so compiled you can use the following sample setup. On Debian, before compiling asterisk, just install libpqxx-dev. Other distros will likely have a similiar package.

Once you have the compile done, copy the sample cel_pgsql.conf file or create your own. 

Here is a sample: 

/etc/asterisk/cel_pgsql.conf

```

; Sample Asterisk config file for CEL logging to PostgresSQL 
[global] 
hostname=localhost 
port=5432 
dbname=asterisk 
password=password 
user=postgres 
table=cel 

```

Now create a table in postgresql for your cels 

```

CREATE TABLE cel (
 id serial , 
 eventtype varchar (30) NOT NULL ,
 eventtime timestamp NOT NULL ,
 userdeftype varchar(255) NOT NULL ,
 cid_name varchar (80) NOT NULL , 
 cid_num varchar (80) NOT NULL ,
 cid_ani varchar (80) NOT NULL , 
 cid_rdnis varchar (80) NOT NULL ,
 cid_dnid varchar (80) NOT NULL ,
 exten varchar (80) NOT NULL ,
 context varchar (80) NOT NULL , 
 channame varchar (80) NOT NULL ,
 appname varchar (80) NOT NULL ,
 appdata varchar (80) NOT NULL , 
 amaflags int NOT NULL ,
 accountcode varchar (20) NOT NULL ,
 peeraccount varchar (20) NOT NULL ,
 uniqueid varchar (150) NOT NULL ,
 linkedid varchar (150) NOT NULL , 
 userfield varchar (255) NOT NULL ,
 peer varchar (80) NOT NULL 
);

```
