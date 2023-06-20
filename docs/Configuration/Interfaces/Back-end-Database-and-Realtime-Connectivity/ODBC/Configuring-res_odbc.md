---
title: Configuring res_odbc
pageid: 27200101
---

Overview
========

The **res\_odbc** module for Asterisk can provide Asterisk with connectivity to various database backends through ODBC (a database abstraction layer). Asterisk features such as [Asterisk Realtime Architecture](/Realtime-Database-Configuration), [Call Detail Records](/Call-Detail-Records--CDR-), [Channel Event Logging](/Configuration/Reporting/Channel-Event-Logging-CEL), can connect to a database through res\_odbc.

More details on specific options within configuration are provided in the [sample configuration file](http://svnview.digium.com/svn/asterisk/branches/11/configs/res_odbc.conf.sample?view=markup) included with Asterisk source.

We'll provide a brief guide here on how to get the res\_odbc.so module configured to connect to an existing ODBC installation.

Recompile Asterisk to build required modules

You'll need to rebuild Asterisk with the needed modules.

Other pages on the wiki describe that process:

[Building and Installing Asterisk](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Building-and-Installing-Asterisk)

[Using Menuselect to Select Asterisk Options](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options)

When using menuselect, verify that the **func\_odbc** (you'll probably be using that one) and **res\_odbc** (required) modules will be built. Then, build Asterisk and make sure those modules were built and exist in **/usr/lib/asterisk/modules** (or whatever directory you use).

Configure res\_odbc.conf to connect to your ODBC installation
=============================================================

Find the configuration file, which should typically be located at /etc/asterisk/res\_odbc.conf and provide a basic configuration such as:




---

  
  


```

[asterisk]
enabled => yes
dsn => your-configured-dsn-name
username => your-database-username
password => insecurepassword
pre-connect => yes

```



---


Then start up Asterisk and assuming res\_odbc loads properly on the CLI you can use odbc show to verify a DSN is configured and shows up:




---

  
  


```

rnewton-office-lab\*CLI> odbc show
ODBC DSN Settings
-----------------
 Name: asterisk
 DSN: your-configured-dsn-name
 Last connection attempt: 1969-12-31 18:00:00

```



---


To verify the connection works you should use func\_odbc or something similar to query the data source from Asterisk.

Troubleshooting
===============

If you don't have the **odbc** command at the CLI, check that

* The res\_odbc.so module exists and has proper permissions in /usr/lib/asterisk/modules/
* Your modules.conf to make sure the module isn't noloaded or being prevented from loading somehow
* Debug during Asterisk startup to look for messages regarding res\_odbc.conf (see logger.conf to get things setup)

If you the **odbc show** output shows "Connected: No" then you'll want to try connecting to your ODBC installation from other methods to verify it is working. The Linux tool **isql** is good for that.

