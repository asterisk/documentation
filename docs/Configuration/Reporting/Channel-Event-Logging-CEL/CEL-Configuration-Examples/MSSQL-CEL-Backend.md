---
title: MSSQL CEL Backend
pageid: 5242952
---

Asterisk can currently store Channel Events into an MSSQL database in two different ways: cel\_odbc or cel\_tds 


Channel Event Records can be stored using unixODBC (which requires the FreeTDS package) [cel\_odbc](/cel_odbc) or directly by using just the FreeTDS package [cel\_tds](/cel_tds) 


The following provide some examples known to get asterisk working with mssql. 




---

**Note:**  
Only choose one db connector.

  



---


### ODBC using cel\_odbc


##### Compile, configure, and install the latest unixODBC package:




---

  
  


```


tar -zxvf unixODBC-2.2.9.tar.gz && cd unixODBC-2.2.9 && ./configure --sysconfdir=/etc --prefix=/usr --disable-gui && make && make install 


```



---


##### Compile, configure, and install the latest FreeTDS package:




---

  
  


```


tar -zxvf freetds-0.62.4.tar.gz && cd freetds-0.62.4 && ./configure --prefix=/usr --with-tdsver=7.0 \ --with-unixodbc=/usr/lib && make && make install 


```



---


##### Compile, or recompile, asterisk so that it will now add support for cel\_odbc.




---

  
  


```


make clean && ./configure --with-odbc && make update && make && make install 


```



---


##### Setup odbc configuration files.


These are working examples from my system. You will need to modify for your setup. You are not required to store usernames or passwords here. 


/etc/odbcinst.ini




---

  
  


```


[FreeTDS]
Description = FreeTDS ODBC driver for MSSQL
Driver = /usr/lib/libtdsodbc.so
Setup = /usr/lib/libtdsS.so
FileUsage = 1


```



---


/etc/odbc.ini




---

  
  


```


[MSSQL-asterisk]
description = Asterisk ODBC for MSSQL
driver = FreeTDS
server = 192.168.1.25
port = 1433
database = voipdb
tds\_version = 7.0
language = us\_english 


```



---




---

**WARNING!:**   

Only install one database connector. Do not confuse asterisk by using both ODBC (cel\_odbc) and FreeTDS (cel\_tds). This command will erase the contents of cel\_tds.conf 




---

  
  


```


[ -f /etc/asterisk/cel\_tds.conf ] > /etc/asterisk/cel\_tds.conf 
  



---



```




---




---

**Note:**  
unixODBC requires the freeTDS package, but asterisk does not call freeTDS directly. 

  



---


##### Now set up cel\_odbc configuration files.


These are working samples from my system. You will need to modify for your setup. Define your usernames and passwords here, secure file as well. 


/etc/asterisk/cel\_odbc.conf




---

  
  


```


[global]
dsn=MSSQL-asterisk
username=voipdbuser
password=voipdbpass
loguniqueid=yes 


```



---


##### And finally, create the 'cel' table in your mssql database.




---

  
  


```


CREATE TABLE cel (
 [eventtype] [varchar] (30) NOT NULL , 
 [eventtime] [datetime] NOT NULL , 
 [cidname] [varchar] (80) NOT NULL , 
 [cidnum] [varchar] (80) NOT NULL , 
 [cidani] [varchar] (80) NOT NULL , 
 [cidrdnis] [varchar] (80) NOT NULL , 
 [ciddnid] [varchar] (80) NOT NULL , 
 [exten] [varchar] (80) NOT NULL ,
 [context] [varchar] (80) NOT NULL , 
 [channame] [varchar] (80) NOT NULL ,
 [appname] [varchar] (80) NOT NULL ,
 [appdata] [varchar] (80) NOT NULL ,
 [amaflags] [int] NOT NULL , 
 [accountcode] [varchar] (20) NOT NULL , 
 [uniqueid] [varchar] (32) NOT NULL , 
 [peer] [varchar] (80) NOT NULL ,
 [userfield] [varchar] (255) NOT NULL 
) ;


```



---


Start asterisk in verbose mode, you should see that asterisk logs a connection to the database and will now record every desired channel event at the moment it occurs.


### FreeTDS, using cel\_tds


##### Compile, configure, and install the latest FreeTDS package:




---

  
  


```


tar -zxvf freetds-0.62.4.tar.gz && cd freetds-0.62.4 && ./configure --prefix=/usr --with-tdsver=7.0 make && make install 


```



---


##### Compile, or recompile, asterisk so that it will now add support for cel\_tds.




---

  
  


```


make clean && ./configure --with-tds && make update && make && make install 


```



---




---

**WARNING!:**   

Only install one database connector. Do not confuse asterisk by using both ODBC (cel\_odbc) and FreeTDS (cel\_tds). This command will erase the contents of cel\_odbc.conf 




---

  
  


```


[ -f /etc/asterisk/cel\_odbc.conf ] > /etc/asterisk/cel\_odbc.conf 
  



---



```




---


##### Setup cel\_tds configuration files.


These are working samples from my system. You will need to modify for your setup. Define your usernames and passwords here, secure file as well. 


/etc/asterisk/cel\_tds.conf




---

  
  


```


[global]
hostname=192.168.1.25
port=1433 
dbname=voipdb 
user=voipdbuser 
password=voipdpass 
charset=BIG5


```



---


##### And finally, create the 'cel' table in your mssql database.




---

  
  


```


CREATE TABLE cel ( 
 [eventtype] [varchar] (30) NULL ,
 [eventtime] [datetime] NULL , 
 [cidname] [varchar] (80) NULL , 
 [cidnum] [varchar] (80) NULL , 
 [cidani] [varchar] (80) NULL ,
 [cidrdnis] [varchar] (80) NULL , 
 [ciddnid] [varchar] (80) NULL ,
 [exten] [varchar] (80) NULL , 
 [context] [varchar] (80) NULL , 
 [channame] [varchar] (80) NULL ,
 [appname] [varchar] (80) NULL ,
 [appdata] [varchar] (80) NULL , 
 [amaflags] [varchar] (16) NULL , 
 [accountcode] [varchar] (20) NULL ,
 [uniqueid] [varchar] (32) NULL , 
 [userfield] [varchar] (255) NULL , 
 [peer] [varchar] (80) NULL 
) ;


```



---


Start asterisk in verbose mode, you should see that asterisk logs a connection to the database and will now record every call to the database when it's complete.

