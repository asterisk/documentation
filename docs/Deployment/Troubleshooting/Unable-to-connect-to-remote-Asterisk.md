---
title: Unable to connect to remote Asterisk
pageid: 33521677
---

Overview
========

When first learning Asterisk some users will find they are unable to connect to the Asterisk service.

You may see the below message after running some variation of `asterisk -r`




---

  
  


```

Unable to connect to remote asterisk (does /var/run/asterisk/asterisk.ctl exist?)

```



---


First, let's break down the message.

* "Unable to connect to remote asterisk"

This means you are attempting to connect to Asterisk with a [remote console](/Verbosity-in-Core-and-Remote-Consoles). That is, you are using "asterisk -r" as opposed to "asterisk -c".

* "does /var/run/asterisk/asterisk.ctl exist?"

This is letting you know specifically what file is potentially missing or unable to be accessed.

Now let's find out what asterisk.ctl is and investigate potential causes of this error.

The asterisk.ctl file
=====================

asterisk.ctl is a UNIX Domain Socket file. It is used to pass commands to an Asterisk process and it is how the Asterisk console ("asterisk r" or any variation) communicates with the back-end Asterisk process.

The /var/run/asterisk/ directory
================================

This directory is the default Asterisk run directory. Asterisk will create it the first time it is run. This location is defined in the [Asterisk Main Configuration File](/Asterisk-Main-Configuration-File). As is explained in the [Directory and File Structure](/Directory-and-File-Structure) section; when Asterisk is [running](/Running-Asterisk), you'll see two files here, **asterisk.ctl** and **asterisk.pid**. These are the control socket and the PID(Process ID) files for Asterisk.

Potential Causes and Solutions
==============================

### Cause 1: asterisk.ctl does exist. Your user does not have write permission for this file.

Solution: 

1. To verify, check the permissions of the asterisk.ctl file and also check what user you are currently running as.
2. Switch to the correct user that has access to the /var/run/asterisk/ directory and asterisk.ctl file, or provide your current user with the correct permissions.

### Cause 2: Permissions issue. Asterisk does not have write access to /var/run/asterisk or your user doesn't have write access to asterisk.ctl.

Solution:

1. If /var/run/asterisk does not exist then create it and assign permission to it such that the user that runs Asterisk will have write and read access.
2. If it already exists, simply verify and assign the correct permissions to the directory. You probably want to double-check what user runs Asterisk.

### Cause 3: asterisk.ctl does not exist because Asterisk isn't running. When Asterisk is started it may run briefly and then quickly halt due to an error.

Solution:

You need to find out what error is causing Asterisk to halt and resolve it.

* The quick way is to run Asterisk in root/core console mode and watch for the last messages Asterisk prints out before halting.
	+ ---
	
	  
	  
	
	
	```
	
	asterisk -cvvvvv
	
	```
	
	
	
	---
	
	
	This will start Asterisk in console mode with level 5 verbosity. That should give you plenty to look at.
* Another way is to setup Asterisk [Logging](/Logging) to log what you want to see to a file. You'll need to read up on Asterisk's [Logging Configuration](/Logging-Configuration)
* Asterisk could halt for a variety of reasons. The last messages you see before Asterisk halts will give you a clue. Then you can Google from there or ask the user community.

### Cause 4: SELinux enabled and not properly configured for Asterisk. SELinux not allowing asterisk.ctl to be created.

Solution:

Configuring SELinux is outside the scope of this article.

* Consult an experienced SELinux user or SELinux documentation on how to configure it properly.
* Disable SELinux if you don't require it (Not recommended)
