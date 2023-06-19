---
title: System Libraries
pageid: 4817504
---

In addition to the C compiler, you'll also need a set of system libraries. Essential libraries are used by Asterisk and must be installed before you can compile Asterisk. Core libraries allow compilation of additional core supported features. On most operating systems, you'll need to install both the library and it's corresponding development package.




---

**Tip:**  Development libraries

For most operating systems, the development packages will have -dev or -devel on the end of the name. For example, on a Red Hat Linux system, you'd want to install both the "openssl" and "openssl-devel" packages.

  



---


Asterisk 13
===========

Essential Libraries
-------------------

* libjansson
* libsqlite3
* libxml2
* libxslt
* ncurses
* openssl
* uuid

Core Libraries
--------------

* DAHDI
* [pjproject](/PJSIP-pjproject)
* unixodbc
* libspeex
* libspeexdsp
* libresample
* libcurl3
* libvorbis
* libogg
* [Installing libsrtp](/Installing-libsrtp)
* libical
* libiksemel
* libneon
* libgmime
* libunbound

We recommend you use the package management system of your operating system to install these libraries before compiling and installing Asterisk.




---

**Tip:**  Help Finding the Right Libraries

Asterisk comes with a shell script called install\_prereq.sh in the contrib/scripts sub-directory. If you run install\_prereq test, it will give you the exact commands to install the necessary system libraries on your operating system. If you run install\_prereq install, it will attempt to download and install the prerequisites automatically.

  



---


