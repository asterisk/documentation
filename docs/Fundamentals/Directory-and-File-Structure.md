---
title: Directory and File Structure
pageid: 27200268
---

The top level directories used by Asterisk can be configured in the asterisk.conf configuration file.

Here we'll describe what each directory is used for, and what sub-directories Asterisk will place in each by default. Below each heading you can also see the correlating configuration line in asterisk.conf.

Asterisk Configuration Files
----------------------------

astetcdir => /etc/asteriskThis location is used to store and read Asterisk configuration files. That is generally files with a .conf extension, but other configuration types as well, for example .lua and .ael.

Asterisk Modules
----------------

astmoddir => /usr/lib/asterisk/modulesLoadable modules in Shared Object format (.so) installed by Asterisk or the user should go here.

Various Libraries
-----------------

astvarlibdir => /var/lib/asteriskAdditional library elements and files containing data used in runtime are put here.

On This Page 

Database Directory
------------------

astdbdir => /var/lib/asteriskThis location is used to store the data file for Asterisk's internal database. In Asterisk versions using the SQLite3 database, the file will be named astdb.sqlite3.

Encryption Keys
---------------

astkeydir => /var/lib/asteriskWhen configuring key-based encryption, Asterisk will look in the **keys** subdirectory of this location for the necessary keys.

System Data Directory
---------------------

astdatadir => /var/lib/asteriskBy default, Asterisk sounds are stored and read from the **sounds** subdirectory at this location.

AGI(Asterisk Gateway Interface) Directory
-----------------------------------------

astagidir => /var/lib/asterisk/agi-binWhen using various AGI applications, Asterisk looks here for the AGI scripts by default.

Spool Directories
-----------------

astspooldir => /var/spool/asteriskThis directory is used for storing spool files from various core and module-provided components of Asterisk.

Most of them use their own subdirectories, such as the following:

* dictate
* meetme
* monitor
* outgoing
* recording
* system
* tmp
* voicemail

Running Process Directory
-------------------------

astrundir => /var/run/asteriskWhen Asterisk is running, you'll see two files here, **asterisk.ctl** and **asterisk.pid**. That is the control socket and the PID(Process ID) files for Asterisk.

Logging Output
--------------

astlogdir => /var/log/asteriskWhen Asterisk is configured to provide log file output, it will be stored in this directory.

System Binary Directory
-----------------------

astsbindir => /usr/sbinBy default, Asterisk looks in this directory for any system binaries that it uses, if you move the Asterisk binary itself or any others that it uses, you'll need to change this location.  
  


