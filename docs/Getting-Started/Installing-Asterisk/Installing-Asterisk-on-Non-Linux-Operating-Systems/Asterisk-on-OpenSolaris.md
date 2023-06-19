---
title: Asterisk on (Open)Solaris
pageid: 12550288
---

Asterisk on Solaris 10 and OpenSolaris
--------------------------------------


###### On this page


### Digium's Support Status


According to the README file from 1.6.2: "Asterisk has also been 'ported' and reportedly runs properly on other operating systems as well, including Sun Solaris, Apple's Mac OS X, Cygwin, and the BSD variants." Digium's developers have also been doing a good job of addressing build and run-time issues encountered with Asterisk on Solaris.


### Build Notes


#### Prerequisites


The following packages are recommend for building Asterisk 1.6 and later on OpenSolaris:


* SUNWlibm (math library)
* gcc-dev (compiler and several dependencies)
* SUNWflexlex (GNU flex)
* SUNWggrp (GNU grep)
* SUNWgsed (GNU sed)
* SUNWdoxygen (optional; needed for "make progdocs")
* SUNWopenldap (optional; needed for res\_config\_ldap; see below)
* SUNWgnu-coreutils (optional; provides GNU install; see below)


Caution: installing SUNW gnu packages will change the default application run when the user types 'sed' and 'grep' from /usr/bin/sed to /usr/gnu/bin/sed. Just be aware of this change, as there are differences between the Sun and GNU versions of these utilities.


#### LDAP dependencies


Because OpenSolaris ships by default with Sun's LDAP libraries, you must install the SUNWopenldap package to provide OpenLDAP libraries. Because of namespace conflicts, the standard LDAP detection will not work.


There are two possible solutions:


1. Port res\_config\_ldap to use only the RFC-specified API. This should allow it to link against Sun's LDAP libraries.
	* The problem is centered around the use of the OpenLDAP-specific ldap\_initialize() call.
2. Change the detection routines in configure to use OpenSolaris' layout of OpenLDAP.
	* This seems doubtful simply because the filesystem layout of SUNWopenldap is so non-standard.


Despite the above two possibilities, there is a workaround to make Asterisk compile with res\_config\_ldap.


* Modify the "configure" script, changing all instances of "-lldap" to "-lldap-2.4".
	+ At the time of this writing there are only 4 instances. This alone will make configure properly detect LDAP availability. But it will not compile.
* When running make, specify the use of the OpenLDAP headers like this:



---

  
  


```


"make LDAP\_INCLUDE=-I/usr/include/openldap"


```



---


#### Makefile layouts


This has been fixed in Asterisk 1.8 and is no longer an issue.


In Asterisk 1.6 the Makefile overrides any usage of --prefix. I suspect the assumptions are from back before configure provided the ability to set the installation prefix. Regardless, if you are building on OpenSolaris, be aware of this behavior of the Makefile!


If you want to alter the install locations you will need to hand-edit the Makefile. Search for the string "SunOS" to find the following section:




---

  
  


```


# Define standard directories for various platforms
# These apply if they are not redefined in asterisk.conf
ifeq ($(OSARCH),SunOS)
 ASTETCDIR=/etc/asterisk
 ASTLIBDIR=/opt/asterisk/lib
 ASTVARLIBDIR=/var/opt/asterisk
 ASTDBDIR=$(ASTVARLIBDIR)
 ASTKEYDIR=$(ASTVARLIBDIR)
 ASTSPOOLDIR=/var/spool/asterisk
 ASTLOGDIR=/var/log/asterisk
 ASTHEADERDIR=/opt/asterisk/include/asterisk
 ASTBINDIR=/opt/asterisk/bin
 ASTSBINDIR=/opt/asterisk/sbin
 ASTVARRUNDIR=/var/run/asterisk
 ASTMANDIR=/opt/asterisk/man
else


```



---


Note that, despite the comment, these definitions have build-time and run-time implications. Make sure you make these changes BEFORE you build!


#### FAX support with SpanDSP


I have been able to get this to work reliably, including T.38 FAX over SIP. If you are running Asterisk 1.6 note [Ticket 16342](https://github.com/asterisk/asterisk/issues/view.php?id=16342) if you do not install SpanDSP to the default locations (/usr/include and /usr/lib).


There is one build issue with SpanDSP that I need to document (FIXME)


### Gotchas


#### Runtime issues


* WAV and WAV49 files are not written correctly (see [Ticket 16610](https://github.com/asterisk/asterisk/issues/view.php?id=16610))
* 32-bit binaries on Solaris are limited to 255 file descriptors by default. (see <http://developers.sun.com/solaris/articles/stdio_256.html>)


#### Build issues


* bootstrap.sh does not correctly detect OpenSolaris build tools (see [Ticket 16341](https://github.com/asterisk/asterisk/issues/view.php?id=16341))
* Console documentation is not properly loaded at startup (see [Ticket 16688](https://github.com/asterisk/asterisk/issues/view.php?id=16688))
* Solaris sed does not properly create AEL parser files (see [Ticket 16696](https://github.com/asterisk/asterisk/issues/view.php?id=16696); workaround is to install GNU sed with SUNWgsed)
* Asterisk's provided install script, install-sh, is not properly referenced in the makeopts file that is generated during the build. One workaround is to install GNU install from the SUNWgnu-coreutils package. (See [Ticket 16781](https://github.com/asterisk/asterisk/issues/view.php?id=16781))


Finally, Solaris memory allocation seems far more sensitive than Linux. This has resulted in the discovery of several previously unknown bugs related to uninitialized variables that Linux handled silently. Note that this means, until these bugs are found and fixed, you may get segfaults.


At the time of this writing I have had a server up and running reasonably stable. However, there are large sections of Asterisk's codebase I do not use and likely contain more of these uninitialized variable problems and associated potential segfaults.


