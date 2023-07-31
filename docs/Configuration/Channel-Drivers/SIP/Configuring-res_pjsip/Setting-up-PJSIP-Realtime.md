---
title: Setting up PJSIP Realtime
pageid: 26478274
---

Overview
========

This tutorial describes the configuration of Asterisk's PJSIP channel driver with the "realtime" database storage backend.  The realtime interface allows storing much of the configuration of PJSIP, such as endpoints, auths, aors and more, in a database, as opposed to the normal flat-file storage of pjsip.conf.

Installing Dependencies
-----------------------

For the purposes of this tutorial, we will assume a base Ubuntu 12.0.4.3 x86_64 server installation, with the OpenSSH server and LAMP server options, and that Asterisk will use its [ODBC](http://www.unixodbc.org/) connector to reach a back-end [MySQL](http://www.mysql.com/) database.

Beyond the normal packages needed to install Asterisk 12 on such a server (build-essential, libncurses5-dev, uuid-dev, libjansson-dev, libxml2-dev, libsqlite3-dev) as well as the [Installation of pjproject](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/PJSIP-pjproject), you will need to install the following packages:

* unixodbc and unixodbc-dev
	+ ODBC and the development packages for building against ODBC
* libmyodbc
	+ The ODBC to MySQL interface package
* python-dev and python-pip
	+ The Python development package and the pip package to allow installation of Alembic
* python-mysqldb
	+ The Python interface to MySQL, which will be used by Alembic to generate the database tables

So, from the CLI, perform:




```bash title=" " linenums="1"
# apt-get install unixodbc unixodbc-dev libmyodbc python-dev python-pip python-mysqldb

```


Once these packages are installed, check your Asterisk installation's **make menuconfig** tool to make sure that the **res_config_odbc** and **res_odbc** resource modules, as well as the **res_pjsip_xxx** modules are selected for installation.  If they are, then go through the normal Asterisk installation process: **./configure; make; make install**

And, if this is your first installation of Asterisk, be sure to install the sample files: **make samples**

Creating the MySQL Database
---------------------------

Use the **mysqladmin** tool to create the database that we'll use to store the configuration.  From the Linux CLI, perform:




```bash title=" " linenums="1"
# mysqladmin -u root -p create asterisk

```


This will prompt you for your MySQL database password and then create a database named **asterisk** that we'll use to store our PJSIP configuration.

Installing and Using Alembic
----------------------------

Alembic is a full database migration tool, with support for upgrading the schemas of existing databases, versioning of schemas, creation of new tables and databases, and a whole lot more.  A good guide on using Alembic with Asterisk can be found on the [Managing Realtime Databases with Alembic](/Managing-Realtime-Databases-with-Alembic) wiki page.  A shorter discussion of the steps necessary to prep your database will follow.

First, install Alembic:




```bash title=" " linenums="1"
# pip install alembic

```


Then, move to the Asterisk source directory containing the Alembic scripts:




```bash title=" " linenums="1"
# cd contrib/ast-db-manage/

```


Next, edit the **config.ini.sample** file and change the **sqlalchemy.url** option, e.g.




---

  
  


```

sqlalchemy.url = mysql://root:password@localhost/asterisk

```


such that the URL matches the username and password required to access your database.

Then rename the config.ini.sample file to config.ini




```bash title=" " linenums="1"
# cp config.ini.sample config.ini

```


Finally, use Alembic to setup the database tables:




```bash title=" " linenums="1"
# alembic -c config.ini upgrade head

```


You'll see something similar to:




```bash title=" " linenums="1"
# alembic -c config.ini upgrade head
INFO [alembic.migration] Context impl MySQLImpl.
INFO [alembic.migration] Will assume non-transactional DDL.
INFO [alembic.migration] Running upgrade None -> 4da0c5f79a9c, Create tables
INFO [alembic.migration] Running upgrade 4da0c5f79a9c -> 43956d550a44, Add tables for pjsip
#

```


You can then connect to MySQL to see that the tables were created:




```bash title=" " linenums="1"
# mysql -u root -p -D asterisk

mysql> show tables;
+--------------------+
| Tables_in_asterisk |
+--------------------+
| alembic_version |
| iaxfriends |
| meetme |
| musiconhold |
| ps_aors |
| ps_auths |
| ps_contacts |
| ps_domain_aliases |
| ps_endpoint_id_ips |
| ps_endpoints |
| sippeers |
| voicemail |
+--------------------+
12 rows in set (0.00 sec)
mysql> quit

```


Configuring ODBC
----------------

Now that we have our MySQL database created and populated, we'll need to setup ODBC and Asterisk's ODBC resource to access the database.  First, we'll tell ODBC how to connect to MySQL.  To do this, we'll edit the  */etc/odbcinst.ini** configuration file.  Your file should look something like:




---

  
/etc/odbcinst.ini  


```

[MySQL]
Description = ODBC for MySQL
Driver = /usr/lib/x86_64-linux-gnu/odbc/libmyodbc.so
Setup = /usr/lib/x86_64-linux-gnu/odbc/libodbcmyS.so
UsageCount = 2

```


Next, we'll tell ODBC **which** MySQL database to use.  To do this, we'll edit the  */etc/odbc.ini** configuration file and create a database handle called **asterisk**.  Your file should look something like:




---

  
/etc/odbc.ini  


```

[asterisk]
Driver = MySQL
Description = MySQL connection to ‘asterisk’ database
Server = localhost
Port = 3306
Database = asterisk
UserName = root
Password = password
Socket = /var/run/mysqld/mysqld.sock

```


Take care to use your database access UserName and Password, and not necessarily what's defined in this example.

Now, we need to configure Asterisk's ODBC resource, res_odbc, to connect to the ODBC **asterisk** database handle that we just created.  res_odbc is configured using the  */etc/asterisk/res_odbc.conf** configuration file.  There, you'll want:




---

  
/etc/asterisk/res_odbc.conf  


```

[asterisk]
enabled => yes
dsn => asterisk
username => root
password => password
pre-connect => yes

```


Again, take care to use the proper username and password.

Now, you can start Asterisk and you can check its connection to your "asterisk" MySQL database using the "asterisk" res_odbc connector to ODBC.  You can do this by executing "odbc show" from the Asterisk CLI.  If everything went well, you'll see:




```bash title=" " linenums="1"
# asterisk -vvvvc
\*CLI> odbc show
 
ODBC DSN Settings
-----------------
 Name: asterisk
 DSN: asterisk
 Last connection attempt: 1969-12-31 18:00:00
 Pooled: No
 Connected: Yes
\*CLI> 

```


Connecting PJSIP Sorcery to the Realtime Database
-------------------------------------------------

The PJSIP stack uses a new data abstraction layer in Asterisk called **sorcery**. Sorcery lets a user build a hierarchical layer of data sources for Asterisk to use when it retrieves, updates, creates, or destroys data that it interacts with. This tutorial focuses on getting PJSIP's configuration stored in a realtime back-end; the rest of the details of sorcery are beyond the scope of this page.

PJSIP bases its configuration on types of objects.  For more information about these types of objects, please refer to the [Configuring res_pjsip](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip) wiki page.  In this case, we have a total of five objects we need to configure in Sorcery:

* endpoint
* auth
* aor
* domain
* identify

We'll also configure the contact object, though we don't need it for this example.

Sorcery is configured using the  */etc/asterisk/sorcery.conf** configuration file.  So, we need to add the following lines to the file:




---

  
/etc/asterisk/sorcery.conf  


```

text[res_pjsip] ; Realtime PJSIP configuration wizard
endpoint=realtime,ps_endpoints
auth=realtime,ps_auths
aor=realtime,ps_aors
domain_alias=realtime,ps_domain_aliases
contact=realtime,ps_contacts
 
[res_pjsip_endpoint_identifier_ip]
identify=realtime,ps_endpoint_id_ips

```


The items use the following nomenclature:




---

  
  


```

{object_type} = {sorcery_wizard_name},{wizard_arguments}

```


In our case, the `sorcery_wizard_name` is **realtime**, and the **wizard_arguments** are the name of the database connector ("asterisk") to associate with our object types. Note that the "identify" object is separated from the rest of the configuration objects. This is because this object type is provided by an optional module (res_pjsip_endpoint_idenfifier_ip.so) and not the main PJSIP module (res_pjsip.so). 

Optionally configuring sorcery for realtime and non-realtime data sources
-------------------------------------------------------------------------

If you want to configure **both realtime and static configuration** file lookups for PJSIP then you need to add additional lines to the sorcery config.

For example if you want to read **endpoints** from both realtime and static configuration:




---

  
  


```

endpoint=realtime,ps_endpoints
endpoint=config,pjsip.conf,criteria=type=endpoint

```


You can swap the order to control which data source is read first.

Realtime Configuration
----------------------

Since we've associated the PJSIP objects with database connector types, we now need to tell Asterisk to use a database backend with the object types, and not just the flat pjsip.conf file.  To do this, we modify the  */etc/asterisk/extconfig.conf** configuration file to provide these connections.

Open extconfig.conf (/etc/asterisk/extconfig.conf) and add the following lines to the 'settings' configuration section




---

  
/etc/asterisk/extconfig.conf  


```

text[settings]
ps_endpoints => odbc,asterisk
ps_auths => odbc,asterisk
ps_aors => odbc,asterisk
ps_domain_aliases => odbc,asterisk
ps_endpoint_id_ips => odbc,asterisk
ps_contacts => odbc,asterisk
 

```




!!! info ""
    Other tables allowed but not demonstrated in this tutorial: ps_systems, ps_globals, ps_transports, and ps_registrations.

      
[//]: # (end-info)



 

At this point, Asterisk is nearly ready to use the tables created by alembic with PJSIP to configure endpoints, authorization, AORs, domain aliases, and endpoint identifiers.




!!! warning A warning for adventurous types:
    Sorcery.conf allows you to try to configure other PJSIP objects such as transport using realtime and it currently won't stop you from doing so. However, some of these object types should not be used with realtime and this can lead to errant behavior.

      
[//]: # (end-warning)



Asterisk Startup Configuration
------------------------------

Now, we need to configure Asterisk to load its ODBC driver at an early stage of startup, so that it's available when any other modules might need to take advantage of it.  Also, we're going to prevent the old chan_sip channel driver from loading, since we're only worried about PJSIP.

To do this, edit the  */etc/asterisk/modules.conf** configuration file.  In the **[modules]** section, add the following lines:




---

  
/etc/asterisk/modules.conf  


```

preload => res_odbc.so
preload => res_config_odbc.so
noload => chan_sip.so 

```


Asterisk PJSIP configuration
----------------------------

Next, we need to configure a transport in  */etc/asterisk/pjsip.conf**.  PJSIP transport object types are not stored in realtime as unexpected results can occur.  So, edit it and add the following lines:




---

  
/etc/asterisk/pjsip.conf  


```

[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0

```


Here, we created a transport called **transport-udp** that we'll reference in the next section.

Endpoint Population
-------------------

Now, we need to create our endpoints inside of the database.  For this example, we'll create two peers, 101 and 102, that register using the totally insecure passwords "101" and "102" respectively.  Here, we'll be populating data directly into the database using the MySQL interactive tool.




```bash title=" " linenums="1"
# mysql -u root -p -D asterisk;
mysql> insert into ps_aors (id, max_contacts) values (101, 1);
mysql> insert into ps_aors (id, max_contacts) values (102, 1);
mysql> insert into ps_auths (id, auth_type, password, username) values (101, 'userpass', 101, 101);
mysql> insert into ps_auths (id, auth_type, password, username) values (102, 'userpass', 102, 102);
mysql> insert into ps_endpoints (id, transport, aors, auth, context, disallow, allow, direct_media) values (101, 'transport-udp', '101', '101', 'testing', 'all', 'g722', 'no');
mysql> insert into ps_endpoints (id, transport, aors, auth, context, disallow, allow, direct_media) values (102, 'transport-udp', '102', '102', 'testing', 'all', 'g722', 'no');
mysql> quit;

```


In this example, we first created an **aor** for each peer, one called **101** and the other **102**.

Next, we created an **auth** for each peer with a userpass of **101** and **102**, respectively.

Then, we created two endpoints, **101** and **102**, each referencing the appropriate **auth** and **aor**, we selected the G.722 codec and we forced media to route inside of Asterisk (not the default behavior of Asterisk).

Now, you can start Asterisk and you can check to see if it's finding your PJSIP endpoints in the database.  You can do this by executing "pjsip show endpoints" from the Asterisk CLI.  If everything went well, you'll see:




```bash title=" " linenums="1"
# asterisk -vvvvc
\*CLI> pjsip show endpoints
Endpoints:
101
102
\*CLI> 

```


A Little Dialplan
-----------------

Now that we have our PJSIP endpoints stored in our MySQL database, let's add a little dialplan so that they can call each other.  To do this, edit Asterisk's  */etc/asterisk/extensions.conf** file and add the following lines to the end:




---

  
/etc/asterisk/extensions.conf  


```

[testing]
exten => _1XX,1,NoOp()
same => n,Dial(PJSIP/${EXTEN})

```


Or to dial multiple AOR contacts at the same time, use the PJSIP_DIAL_CONTACTS function:




---

  
/etc/asterisk/extensions.conf  


```

[testing]
exten => _1XX,1,NoOp()
same => n,Dial(${PJSIP_DIAL_CONTACTS(${EXTEN})})

```


Reserved Characters
-------------------

Realtime uses the semicolon ( ; ) as a delimiter for multiple entries.  It must be replaced with "^3B" to prevent the data from being interpreted as multiple entries.




!!! info ""
    "^3B" is the corresponding byte value of the semicolon character in ASCII, represented as a pair of hexadecimal digits, preceded by a caret ( ^ ) acting as the escape character.  
[//]: # (end-info)



 

For example, this outbound_proxy parameter




---

  
  


```

sip:10.30.100.28:5060;lr

```


should be stored in the database as




---

  
  


```

sip:10.30.100.28:5060^3Blr

```


Conclusion
----------

Now, start Asterisk back up, or reload it using **core reload** from the Asterisk CLI, register your two SIP phones using the 101/101 and 102/102 credentials, and make a call.

