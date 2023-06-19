---
title: Test Asterisk Configuration Files
pageid: 47874652
---

Introduction
============

Asterisk instances started by the Testsuite get their configuration files from 3 sources in order

1. /etc/asterisk which should be the result of a clean "make samples" run in the Asterisk source tree.
2. The Testsuite's common config files located in <TESTSUITE\_DIR>/configs
3. The test's own configs and files directories.

Most of the files are handled simply where a file in the test's configs/astX directory replaces one found in the Testsuite's directory and one in the Testsuite's directory replaces one in /etc/asterisk.  Some have another level of processing though. 

* logger.conf:  Your test can specify additional options for the "general" and "logfiles" categories by placing them in files named "logger.general.conf.inc" and "logger.logfiles.conf.inc" respectively.
* manager.conf: Your test can specify additional options for the "general" and "user" categories by placing them in files named "manager.general.conf.inc" and "manager.user.conf.inc" respectively.
* modules.conf: Your test can specify additional modules to load or disable by placing "load", "preload" or "noload" directives in "modules.conf.inc".  NOTE:  The default behavior is "autoload" so you generally don't have to (and shouldn't) load them yourself this way.

Test Directory Layout
=====================

Most test directories will have the following structure:




---

  
  


```

<test\_name>/
 configs/ Contains configuration files to go in each Asterisk instance's virtual /etc/asterisk directory.
 ast1/ All tests have at least 1 Asterisk instance.
 ...
 astN/ Many tests have additional Asterisk instances. 
 files/ Contains other files like keys, licenses, etc that need to be copied to specific locations.
 common/ Files and directories in this directory in this tree will be copied to all Asterisk instances.
 Each subdirectory represents a corresponding entry in the asterisk.conf "directories" category.
 You only need to create the subdirectories you need.
 astmoddir/
 astvarlibdir/
 astdbdir/
 astkeydir/
 astdatadir/
 astagidir/
 astspooldir/
 astrundir/
 astlogdir/
 ast1/ Same structure as "common" but only for Asterisk instance 1.
 ...
 astN/ 
 sipp/ (only if sipp is being used)
 test-config.yaml (required)



```



---


 

Files placed in any of the "ast\*dir" directories can be referenced by configuration files in the "configs" tree using their symbolic directory location. For example, let's say that you're testing TLS transports between two asterisk instances.  Your test directory structure might look like this:




---

  
  


```

<test\_name>/
 configs/
 ast1/
 extensions.conf
 pjsip.conf
 ast1/
 extensions.conf
 pjsip.conf
 files/
 common/
 astvarlibdir/
 keys/
 ca-cert.pem
 ast1/
 astvarlibdir/
 keys/
 ast1-cert.pem
 ast1-key.pem
 ast2/
 astvarlibdir/
 keys/
 ast2-cert.pem
 ast2-key.pem
 test-config.yaml (required)


```



---


The ca-cert.pem file would be copied to both instance's /var/lib/asterisk/keys directories while ast1-cert.pem and ast1-key.pem would only be copied to the first Asterisk instance's and ast2-cert.pem and ast2-key.pem would only be copied to the second Asterisk instance's.

Your config files would then look line this:




---

  
  


```

; First Asterisk instance's pjsip.conf
[transport-tls]
type=transport
protocol = tls
ca\_list\_file = <astvarlibdir>>/keys/ca.pem
cert\_file = <astvarlibdir>>/keys/ast1-cert.pem
priv\_key\_file = <astvarlibdir>>/keys/ast1-key.pem

```



---


The second Asterisk instance's pjsip.conf file would look similar except that "ast1" would be changed to "ast2".




---

**WARNING!:**   
Files like keys (and the directories that contain them) usually have permissions restrictions, such as being only readable by the owner. Make sure your files have the correct permission before you commit them so those permissions are preserved when they are copied to their final locations. The user and group don't matter. Most people, including Jenkins, run the Testsuite as root.

  



---


 

 

