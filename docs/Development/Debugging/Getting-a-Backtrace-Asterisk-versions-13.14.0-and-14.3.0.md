---
title: Getting a Backtrace (Asterisk versions < 13.14.0 and 14.3.0)
pageid: 5243139
---

This document is intended to provide information on how to obtain the backtraces required on the asterisk bug tracker, available at <https://github.com/asterisk/asterisk/issues>.

Overview
--------

The backtrace information is required by developers to help fix problems with bugs of any kind. Backtraces provide information about what was wrong when a program crashed; in our case, Asterisk.

Preparing Asterisk To Produce Core Files On Crash
-------------------------------------------------

First of all, when you start Asterisk, you MUST start it with option -g. This tells Asterisk to produce a core file if it crashes.

If you start Asterisk with the safe\_asterisk script, it automatically starts using the option -g.

If you're not sure if Asterisk is running with the -g option, type the following command in your shell:




---

  
  


```

# ps -C asterisk u
USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
root 3018 1.1 2.7 636212 27768 pts/1 Sl+ 08:06 0:00 asterisk -vvvvvg -c
[...]


```



---


The interesting information is located in the last column.

Second, your copy of Asterisk must have been built without optimization or the backtrace will be (nearly) unusable. This can be done by selecting the 'DONT\_OPTIMIZE' option in the Compiler Flags submenu in the 'make menuselect' tree before building Asterisk.




---

**Note:**  

| Using BETTER\_BACKTRACES |
| --- |
| As of Asterisk versions 1.4.40, 1.6.2.17, and 1.8.3, the option BETTER\_BACKTRACES which uses libbfd, will provide better symbol information within both the Asterisk binary, as well as loaded modules, to assist when using inline backtraces to track down problems. **It is recommended that you enable both DONT\_OPTIMIZE and BETTER\_BACKTRACES** |

  



---




---

**Tip:**  libbfd is included in the binutils-devel package on CentOS / RHEL, or the binutils-dev package on Debian / Ubuntu.

  



---


Running a production server with DONT\_OPTIMIZE is generally safe. You'll notice the binary files may be a bit larger, but in terms of Asterisk performance, impact should be negligible.

After Asterisk crashes, a file named "core" will be dumped in the present working directory of the Linux shell from which Asterisk was started.

In the event that there are multiple core files present, it is important to look at the file timestamps in order to determine which one you really intend to look at.

Getting Information After A Crash
---------------------------------

There are two kind of backtraces (aka 'bt') which are useful: bt and bt full.

Now that we've verified the core file has been written to disk, the final part is to extract 'bt' from the core file. Core files are pretty big, don't be scared, it's normal.




---

**Note:**  Don't attach core files on the bug tracker as they are only useful on the machine they were generated on. We only need the output of the 'bt' and 'bt full.'

  



---


For extraction, we use a really nice tool, called gdb. To verify that you have gdb installed on your system:




---

  
  


```

# gdb -v
GNU gdb 6.8-debian
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law. Type "show copying"
and "show warranty" for details.
This GDB was configured as "i486-linux-gnu"...


```



---


If you don't have gdb installed, go install gdb. You should be able to install using something like: apt-get install gdb **or** yum install gdb




---

**Tip:**  Just run the following command to get the output into the backtrace.txt file, ready for uploading to the issue tracker. Be sure to change the name of the core file to your actual core dump file:

  



---




---

  
  


```

# gdb -se "asterisk" -ex "bt full" -ex "thread apply all bt" --batch -c core > /tmp/backtrace.txt


```



---


Now load the core file in gdb with the following command. This will also save the output of gdb to the /tmp/backtract.txt file.




---

  
  


```

# gdb -se "asterisk" -c core | tee /tmp/backtrace.txt
[...]
(You would see a lot of output here.)
[...]
Reading symbols from /usr/lib/asterisk/modules/app\_externalivr.so...done.
Loaded symbols for /usr/lib/asterisk/modules/app\_externalivr.so
#0 0x29b45d7e in ?? ()
(gdb)


```



---


In order to make extracting the gdb output easier, you may wish to turn on logging using "set logging on". This command will save all output to the default file of gdb.txt, which in the end can be uploaded as an attachment to the bug tracker.

Now at the gdb prompt, type: bt You would see output similar to:




---

  
  


```

(gdb) bt
#0 0x29b45d7e in ?? ()
#1 0x08180bf8 in ?? ()
#2 0xbcdffa58 in ?? ()
#3 0x08180bf8 in ?? ()
#4 0xbcdffa60 in ?? ()
#5 0x08180bf8 in ?? ()
#6 0x180bf894 in ?? ()
#7 0x0bf80008 in ?? ()
#8 0x180b0818 in ?? ()
#9 0x08068008 in ast\_stopstream (tmp=0x40758d38) at file.c:180
#10 0x000000a0 in ?? ()
#11 0x000000a0 in ?? ()
#12 0x00000000 in ?? ()
#13 0x407513c3 in confcall\_careful\_stream (conf=0x8180bf8, filename=0x8181de8 "DAHDI/pseudo-1324221520") at app\_meetme.c:262
#14 0x40751332 in streamconfthread (args=0x8180bf8) at app\_meetme.c:1965
#15 0xbcdffbe0 in ?? ()
#16 0x40028e51 in pthread\_start\_thread () from /lib/libpthread.so.0
#17 0x401ec92a in clone () from /lib/libc.so.6
(gdb)


```



---


The bt's output is the information that we need on the bug tracker.

Now do a bt full as follows:




---

  
  


```

(gdb) bt full
#0 0x29b45d7e in ?? ()
No symbol table info available.
#1 0x08180bf8 in ?? ()
No symbol table info available.
#2 0xbcdffa58 in ?? ()
No symbol table info available.
#3 0x08180bf8 in ?? ()
No symbol table info available.
#4 0xbcdffa60 in ?? ()
No symbol table info available.
#5 0x08180bf8 in ?? ()
No symbol table info available.
#6 0x180bf894 in ?? ()
No symbol table info available.
#7 0x0bf80008 in ?? ()
No symbol table info available.
#8 0x180b0818 in ?? ()
No symbol table info available.
#9 0x08068008 in ast\_stopstream (tmp=0x40758d38) at file.c:180
No locals.
#10 0x000000a0 in ?? ()
No symbol table info available.
#11 0x000000a0 in ?? ()
No symbol table info available.
#12 0x00000000 in ?? ()
No symbol table info available.
#13 0x407513c3 in confcall\_careful\_stream (conf=0x8180bf8, filename=0x8181de8 "DAHDI/pseudo-1324221520") at app\_meetme.c:262
 f = (struct ast\_frame \*) 0x8180bf8
 trans = (struct ast\_trans\_pvt \*) 0x0
#14 0x40751332 in streamconfthread (args=0x8180bf8) at app\_meetme.c:1965
No locals.
#15 0xbcdffbe0 in ?? ()
No symbol table info available.
#16 0x40028e51 in pthread\_start\_thread () from /lib/libpthread.so.0
No symbol table info available.
#17 0x401ec92a in clone () from /lib/libc.so.6
No symbol table info available.
(gdb)


```



---


The final "extraction" would be to know all traces by all threads. Even if Asterisk runs on the same thread for each call, it could have created some new threads.

To make sure we have the correct information, just do:




---

  
  


```

(gdb) thread apply all bt

Thread 1 (process 26252):
#0 0x29b45d7e in ?? ()
#1 0x08180bf8 in ?? ()
#2 0xbcdffa58 in ?? ()
#3 0x08180bf8 in ?? ()
#4 0xbcdffa60 in ?? ()
#5 0x08180bf8 in ?? ()
#6 0x180bf894 in ?? ()
#7 0x0bf80008 in ?? ()
#8 0x180b0818 in ?? ()
#9 0x08068008 in ast\_stopstream (tmp=0x40758d38) at file.c:180
#10 0x000000a0 in ?? ()
#11 0x000000a0 in ?? ()
#12 0x00000000 in ?? ()
#13 0x407513c3 in confcall\_careful\_stream (conf=0x8180bf8, filename=0x8181de8 "DAHDI/pseudo-1324221520") at app\_meetme.c:262
#14 0x40751332 in streamconfthread (args=0x8180bf8) at app\_meetme.c:1965
#15 0xbcdffbe0 in ?? ()
#16 0x40028e51 in pthread\_start\_thread () from /lib/libpthread.so.0
#17 0x401ec92a in clone () from /lib/libc.so.6
(gdb)


```



---


That output tells us crucial information about each thread.

Getting Information For A Deadlock
----------------------------------

Whenever collecting information about a deadlock it is useful to have additional information about the threads involved. We can generate this information by attaching to a running Asterisk process and gathering that information. Follow the two steps below to collect debug that will be useful to Asterisk developers.




---

**Note:**  In the Compiler Flags menu of menuselect and you should enable **DEBUG\_THREADS**, **DONT\_OPTIMIZE** and **BETTER\_BACKTRACES**. Then, you need to recompile, re-install, and restart Asterisk before following the steps below.

  



---


**Use GDB to collect a backtrace:** You can easily attach to a running Asterisk process, gather the output required and then detach from the process all in a single step. Since this gathers information from the running Asterisk process,  you want to make sure you run this command immediately before or after gathering the output of '[core show locks](/CLI-commands-useful-for-debugging)'. Execute the following command and upload the resulting backtrace-threads.txt file to the Asterisk issue tracker:




---

  
  


```

# gdb -ex "thread apply all bt" --batch /usr/sbin/asterisk `pidof asterisk` > /tmp/backtrace-threads.txt


```



---


**Collecting output from the "core show locks" CLI command :** After getting the backtrace with GDB, immediately run the following command from your Linux shell:




---

  
  


```

# asterisk -rx "core show locks" > /tmp/core-show-locks.txt

```



---


For more info on: [Locking in Asterisk](/Locking-in-Asterisk)

Verify Your Backtraces
----------------------

Before uploading your backtraces to the issue tracker, you should double check to make sure the data you have is of use to the developers.

Check your backtrace files to make sure you compiled with **DONT\_OPTIMIZE**:




---

  
  


```

<value optimized out>


```



---


If you are seeing the above text in your backtrace, then you likely haven't compiled with DONT\_OPTIMIZE. The impact of DONT\_OPTIMIZE is negligible on most systems, so go ahead and enable it as with optimizations the backtraces are often not useful to the developers. Be sure you've enabled the DONT\_OPTIMIZE flag within the Compiler Flags section of menuselect. After doing so, be sure to run 'make && make install' and restart Asterisk.

If you are getting a backtrace for a deadlock then be sure you compiled with **DEBUG\_THREADS**. One way to verify this is by checking your backtrace for a thread calling **ast\_rentrancy\_lock**. For example:




---

  
  


```

#2 0x0813c6c7 in ast\_reentrancy\_lock (lt=0x6b736972) at /usr/local/src/asterisk-11.14/asterisk-11.14.0-rc1/include/asterisk/lock.h:420
 res = 135518668

```



---


If unsure, simply add the [compiler flag in menuselect](/Using-Menuselect-to-Select-Asterisk-Options) and [recompile then reinstall Asterisk](/Building-and-Installing-Asterisk).

Identifying Potential Memory Corruption
---------------------------------------

When you look at a backtrace, you'll usually see one of two things that indicate a memory corruption:

1. A seg fault or an abort in malloc, calloc, or realloc. This could also be an indication that someone ran out of memory, but usually Asterisk "gracefully" handles that condition (although the system will more then likely tank pretty quickly, you'll get some ERROR messages). In general, a seg fault or abort in one of those three is very likely to be a memory corruption.

2. An abort or seg fault in free. That's pretty much always a memory corruption.

If you think there is a memory corruption issue then you'll want to run [valgrind](/Valgrind) to investigate further.

Uploading Your Information To The Issue Tracker
-----------------------------------------------

You're now ready to upload your files to the Asterisk issue tracker (located at <https://github.com/asterisk/asterisk/issues>).




---

**Note:**  Please ATTACH your output! DO NOT paste it as a note!

The menu item is located on the JIRA issue report under: ( More > Attach Files )

  



---


Questions?
==========

If you have questions or comments regarding this documentation, feel free to pass by the #asterisk-bugs channel on irc.freenode.net.

