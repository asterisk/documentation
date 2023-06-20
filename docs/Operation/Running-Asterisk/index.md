---
title: Overview
pageid: 27200195
---

Running Asterisk from the Command Line
======================================

* By default, starting Asterisk will run it in the background:




---

  
  


```

# asterisk

# ps aux | grep asterisk
my\_user 26246 2.0 4.1 2011992 165520 ? Ssl 16:35 0:16 asterisk

```



---
* In order to connect to a running Asterisk process, you can attach a **remote console** using the `-r` option:




---

  
  


```

# asterisk -r

Asterisk 11.9.0, Copyright (C) 1999 - 2014 Digium, Inc. and others.
Created by Mark Spencer <markster@digium.com>
Asterisk comes with ABSOLUTELY NO WARRANTY; type 'core show warranty' for details.
This is free software, with components licensed under the GNU General Public
License version 2 and other licenses; you are welcome to redistribute it under
certain conditions. Type 'core show license' for details.
=========================================================================
Connected to Asterisk 11.9.0 currently running on asterisk-server (pid = 26246)
asterisk-server\*CLI> 

```



---




---

**Tip:**  The `-R` option will also attach a remote console - however, it will attempt to automatically reconnect to Asterisk if for some reason the connection is broken. This is particularly useful if your remote console restarts Asterisk.

  



---
On this Page* To disconnect from a connected remote console, simply hit **Ctrl+C**:




---

  
  


```

asterisk-server\*CLI> 
Disconnected from Asterisk server
Asterisk cleanly ending (0).
Executing last minute cleanups

```



---
* To shut down Asterisk, issue `core stop gracefully`:




---

  
  


```

asterisk-server\*CLI> core stop gracefully
Disconnected from Asterisk server
Asterisk cleanly ending (0).
Executing last minute cleanups

```



---




---

**Tip:**  You can stop/restart Asterisk in many ways. See [Stopping and Restarting Asterisk From The CLI](/Operation/Running-Asterisk/Stopping-and-Restarting-Asterisk-From-The-CLI) for more information.

  



---
* You can start Asterisk in the foreground, with an attached **root console**, using the `-c` option:




---

  
  


```

# asterisk -c

Asterisk 11.9.0, Copyright (C) 1999 - 2014 Digium, Inc. and others.
Created by Mark Spencer <markster@digium.com>
Asterisk comes with ABSOLUTELY NO WARRANTY; type 'core show warranty' for details.
This is free software, with components licensed under the GNU General Public
License version 2 and other licenses; you are welcome to redistribute it under
certain conditions. Type 'core show license' for details.
=========================================================================
Connected to Asterisk 11.9.0 currently running on asterisk-server (pid = 26246)
[May 16 17:02:50] NOTICE[27035]: loader.c:1323 load\_modules: 287 modules will be loaded.
Asterisk Ready.
\*CLI> 

```



---

Adding Verbosity
----------------

Asterisk provides a number of mechanisms to control the verbosity of its logging. One way in which this can be controlled is through the command line parameter `-v`. For each `-v` specified, Asterisk will increase the level of `VERBOSE` messages by 1. The following will create a console and set the `VERBOSE` message level to 2:




---

  
  


```

# asterisk -c -v -v

```



---


Command line parameters can be combined. The previous command can also be invoked in the following way:




---

  
  


```

# asterisk -cvv

```



---




---

**Note:**  The `VERBOSE` message level set via the command line is only applicable if the `asterisk.conf` `verbose` setting is not set.

  



---


### Remote Console Verbosity




---

**Tip:**  **This feature is only available in Asterisk 11 and later versions.**

  



---


The verboseness of a remote console is set independently of the verboseness of other consoles and the core. A root console can be created with no verboseness:




---

  
  


```

# asterisk -c

```



---


While a remote console can be attached to that Asterisk process with a different verbosity:




---

  
  


```

# asterisk -rvvv

```



---


Multiple remote consoles can be attached, each with their own verbosity:




---

  
  


```

# asterisk -rv

```



---


Executing as another User
-------------------------




---

**WARNING!: Do not run as root**  
Running Asterisk as `root` or as a user with super user permissions is dangerous and not recommended. There are many ways Asterisk can affect the system on which it operates, and running as `root` can increase the cost of small configuration mistakes.

For more information, see the [README-SERIOUSLY.bestpractices.md](https://github.com/asterisk/asterisk/blob/master/README-SERIOUSLY.bestpractices.md) file delivered with Asterisk.

  



---


Asterisk can be run as another user using the `-U` option:




---

  
  


```

# asterisk -U asteriskuser

```



---


Often, this option is specified in conjunction with the `-G` option, which specifies the group to run under:




---

  
  


```

# asterisk -U asteriskuser -G asteriskuser

```



---


When running Asterisk as another user, make sure that user owns the various directories that Asterisk will access:




---

  
  


```

# sudo chown -R asteriskuser:asteriskuser /usr/lib/asterisk
# sudo chown -R asteriskuser:asteriskuser /var/lib/asterisk
# sudo chown -R asteriskuser:asteriskuser /var/spool/asterisk
# sudo chown -R asteriskuser:asteriskuser /var/log/asterisk
# sudo chown -R asteriskuser:asteriskuser /var/run/asterisk
# sudo chown asteriskuser:asteriskuser /usr/sbin/asterisk

```



---


More Options
------------

There are many more command line options available. For more information, use the `-h` option:




---

  
  


```

# asterisk -h
Asterisk 11.9.0, Copyright (C) 1999 - 2014, Digium, Inc. and others.
Usage: asterisk [OPTIONS]
...

```



---


Running Asterisk as a Service
=============================

The most common way to run Asterisk in a production environment is as a service. Asterisk includes both a `make` target for installing Asterisk as a service, as well as a script - `live_asterisk` - that will manage the service and automatically restart Asterisk in case of errors.

* Asterisk can be installed as a service using the `make config` target:




---

  
  


```

# make config
 /etc/rc0.d/K91asterisk -> ../init.d/asterisk
 /etc/rc1.d/K91asterisk -> ../init.d/asterisk
 /etc/rc6.d/K91asterisk -> ../init.d/asterisk
 /etc/rc2.d/S50asterisk -> ../init.d/asterisk
 /etc/rc3.d/S50asterisk -> ../init.d/asterisk
 /etc/rc4.d/S50asterisk -> ../init.d/asterisk
 /etc/rc5.d/S50asterisk -> ../init.d/asterisk

```



---
* Asterisk can now be started as a service:




---

  
  


```

# service asterisk start
 \* Starting Asterisk PBX: asterisk [ OK ] 

```



---
* And stopped:




---

  
  


```

# service asterisk stop
 \* Stopping Asterisk PBX: asterisk [ OK ] 

```



---
* And restarted:




---

  
  


```

# service asterisk restart
 \* Stopping Asterisk PBX: asterisk [ OK ] 
 \* Starting Asterisk PBX: asterisk [ OK ]

```



---

Supported Distributions
-----------------------

Not all distributions of Linux/Unix are supported by the `make config` target. The following distributions are supported - if not using one of these distributions, the `make config` target may or may not work for you.

* RedHat/CentOS
* Debian/Ubuntu
* Gentoo
* Mandrake/Mandriva
* SuSE/Novell

 

