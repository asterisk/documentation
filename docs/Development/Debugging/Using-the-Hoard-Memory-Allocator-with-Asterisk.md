---
title: Using the Hoard Memory Allocator with Asterisk
pageid: 4260005
---

Using the Hoard Memory Allocator with Asterisk
==============================================


##### Install the Hoard Memory Allocator


Download Hoard from <http://www.hoard.org/> either via a package or the source tarball.


If downloading the source, unpack the tarball and follow the instructions in the README file to build libhoard for your platform.


##### Configure asterisk


Run ./configure in the root of the asterisk source directory, passing the **--with-hoard** option specifying the location of the libhoard shared library.


For example:




---

  
  


```


./configure --with-hoard=/usr/src/hoard-371/src/


```


Note that we don't specify the full path to libhoard.so, just the directory where it resides.


##### Enable Hoard in menuselect


Run 'make menuselect' in the root of the asterisk source distribution. Under 'Compiler Flags' select the 'USE\_HOARD\_ALLOCATOR' option. If the option is not available (shows up with XXX next to it) this means that configure was not able to find libhoard.so. Check that the path you passed to the **--with-hoard** option is correct. Re-run **./configure** with the correct option and then repeat this step.


##### Make and install asterisk


Run the standard build commands:




```bash title=" " linenums="1"
# make
# make install


```


