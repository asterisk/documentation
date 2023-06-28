---
title: System Libraries
pageid: 4817504
---

In addition to the C compiler, you'll also need a set of system libraries. Essential libraries are used by Asterisk and must be installed before you can compile Asterisk. Core libraries allow compilation of additional core supported features. On most operating systems, you'll need to install both the library and it's corresponding development package.




!!! tip 
    Development libraries

    For most operating systems, the development packages will have -dev or -devel on the end of the name. For example, on a Red Hat Linux system, you'd want to install both the "openssl" and "openssl-devel" packages.

      
[//]: # (end-tip)



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
* [pjproject](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/PJSIP-pjproject)
* unixodbc
* libspeex
* libspeexdsp
* libresample
* libcurl3
* libvorbis
* libogg
* [Installing libsrtp](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Installing-libsrtp)
* libical
* libiksemel
* libneon
* libgmime
* libunbound

We recommend you use the package management system of your operating system to install these libraries before compiling and installing Asterisk.




!!! tip 
    Help Finding the Right Libraries

    Asterisk comes with a shell script called install_prereq.sh in the contrib/scripts sub-directory. If you run install_prereq test, it will give you the exact commands to install the necessary system libraries on your operating system. If you run install_prereq install, it will attempt to download and install the prerequisites automatically.

      
[//]: # (end-tip)



