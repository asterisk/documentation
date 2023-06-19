---
title: Getting a Backtrace
pageid: 36803756
---

This document is intended to provide information on how to obtain the backtraces required on the asterisk bug tracker, available at [https://github.com/asterisk/asterisk/issues](https://github.com/asterisk/asterisk/issues)(https://github.com/asterisk/asterisk/issues/).

BLOCKOverview
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

Second, your copy of Asterisk must have been built without optimization or the backtrace will be (nearly) unusable. This can be done by selecting the 'DONT\_OPTIMIZE' option in the Compiler Flags submenu in the 'make menuselect' tree before building Asterisk.  Running a production server with DONT\_OPTIMIZE is generally safe. You'll notice the binary files may be a bit larger, but in terms of Asterisk performance, impact should be negligible.

Third, your copy of Asterisk must have the debug symbols still included in the binaries.   This is the default unless you, or the package maintainer if installing from packages, strips the binaries.  Normally a package maintainer will strip the binaries and then provide separate "debug" packages that contain just the symbols.  If so, make sure those debug packages are installed.

After Asterisk crashes, a file named "core" will be dumped in the present working directory of the Linux shell from which Asterisk was started or in the location specified by the `kernel.core_pattern` sysctl setting. In the event that there are multiple core files present, it is important to look at the file timestamps in order to determine which one you really intend to look at.

 

Getting Preliminary Information After A Crash
---------------------------------------------

Before you go further, you must have the GNU Debugger (gdb) installed on the machine that experienced the crash.  Use your package manager to install it if it isn't already.




---

**Note:**  Don't attach core files on the bug tracker as they are only useful on the machine they were generated on. We only need the output of ast\_coredumper.

  



---


### ast\_coredumper

Asterisk versions 13.14.0, 14.3.0, and later release branches added a few tools to make debugging easier.  One of these is `ast_coredumper`.   By default, it's installed in `/var/lib/asterisk/scripts` and it takes in a core file and produces backtraces and lock dumps in a format for uploading to Jira.  




---

  
/var/lib/asterisk/scripts/ast\_coredumper --help  


```

trueNAME
 ast\_coredumper - Dump and/or format asterisk coredump files
SYNOPSIS
 ast\_coredumper [ --help ] [ --running | --RUNNING ] [ --latest ]
 [ --tarball-coredumps ] [ --delete-coredumps-after ]
 [ --tarball-results ] [ --delete-results-after ]
 [ --tarball-uniqueid="<uniqueid>" ]
 [ --no-default-search ] [ --append-coredumps ]
 [ <coredump> | <pattern> ... ]
DESCRIPTION
 Extracts backtraces and lock tables from Asterisk coredump files.
 For each coredump found, 4 new result files are created:
 - <coredump>.brief.txt: The output of "thread apply all bt".
 - <coredump>.thread1.txt: The output of "thread apply 1 bt full".
 - <coredump>.full.txt: The output of "thread apply all bt full".
 - <coredump>.locks.txt: If asterisk was compiled with
 "DEBUG\_THREADS", this file will contain a dump of the locks
 table similar to doing a "core show locks" from the asterisk
 CLI.
 Optional features:
 - The running asterisk process can be suspended and dumped.
 - The coredumps can be merged into a tarball.
 - The coredumps can be deleted after processing.
 - The results files can be merged into a tarball.
 - The results files can be deleted after processing.
 Options:
 --help
 Print this help.
 --running
 Create a coredump from the running asterisk instance and
 process it along with any other coredumps found (if any).
 WARNING: This WILL interrupt call processing. You will be
 asked to confirm.
 --RUNNING
 Same as --running but without the confirmation prompt.
 DANGEROUS!!
 --latest
 Process only the latest coredump from those specified (based
 on last-modified time). If a dump of the running process was
 requested, it is always included in addition to the latest
 from the existing coredumps.
 --tarball-coredumps
 Creates a gzipped tarball of all coredumps processed.
 The tarball name will be:
 /tmp/asterisk.<timestamp>.coredumps.tar.gz
 --delete-coredumps-after
 Deletes all processed coredumps regardless of whether
 a tarball was created.
 --tarball-results
 Creates a gzipped tarball of all result files produced.
 The tarball name will be:
 /tmp/asterisk.<timestamp>.results.tar.gz
 --delete-results-after
 Deletes all processed results regardless of whether
 a tarball was created. It probably doesn't make sense
 to use this option unless you have also specified
 --tarball-results.
 --tarball-uniqueid="<uniqueid>"
 Normally DATEFORMAT is used to make the tarballs unique
 but you can use your own unique id in the tarball names
 such as the Jira issue id.
 --no-default-search
 Ignore COREDUMPS from the config files and process only
 coredumps listed on the command line (if any) and/or
 the running asterisk instance (if requested).
 --append-coredumps
 Append any coredumps specified on the command line to the
 config file specified ones instead of overriding them.
 <coredump> | <pattern>
 A list of coredumps or coredump search patterns. Unless
 --append-coredumps was specified, these entries will override
 those specified in the config files.
 Any resulting file that isn't actually a coredump is silently
 ignored. If your patterns contains spaces be sure to only
 quote the portion of the pattern that DOESN'T contain wildcard
 expressions. If you quote the whole pattern, it won't be
 expanded.
 If --no-default-search is specified and no files are specified
 on the command line, then the only the running asterisk process
 will be dumped (if requested). Otherwise if no files are
 specified on the command line the value of COREDUMPS from
 ast\_debug\_tools.conf will be used. Failing that, the following
 patterns will be used:
 /tmp/core[-.\_]asterisk!(\*.txt)
 /tmp/core[-.\_]$(hostname)!(\*.txt)
NOTES
 You must be root to use ast\_coredumper.
 The script relies on not only bash, but also recent GNU date and
 gdb with python support. \*BSD operating systems may require
 installation of the 'coreutils' and 'devel/gdb' packagess and minor
 tweaking of the ast\_debug\_tools.conf file.
 Any files output will have ':' characters changed to '-'. This is
 to facilitate uploading those files to Jira which doesn't like the
 colons.
FILES
 /etc/asterisk/ast\_debug\_tools.conf
 ~/ast\_debug\_tools.conf
 ./ast\_debug\_tools.conf
 #
 # This file is used by the Asterisk debug tools.
 # Unlike other Asterisk config files, this one is
 # "sourced" by bash and must adhere to bash semantics.
 #
 # A list of coredumps and/or coredump search patterns.
 # Bash extended globs are enabled and any resulting files
 # that aren't actually coredumps are silently ignored
 # so you can be liberal with the globs.
 #
 # If your patterns contains spaces be sure to only quote
 # the portion of the pattern that DOESN'T contain wildcard
 # expressions. If you quote the whole pattern, it won't
 # be expanded and the glob characters will be treated as
 # literals.
 #
 # The exclusion of files ending ".txt" is just for
 # demonstration purposes as non-coredumps will be ignored
 # anyway.
 COREDUMPS=(/tmp/core[-.\_]asterisk!(\*.txt) /tmp/core[-.\_]$(hostname)!(\*.txt))
 # Date command for the "running" coredump and tarballs.
 # DATEFORMAT will be executed to get the timestamp.
 # Don't put quotes around the format string or they'll be
 # treated as literal characters. Also be aware of colons
 # in the output as you can't upload files with colons in
 # the name to Jira.
 #
 # Unix timestamp
 #DATEFORMAT='date +%s.%N'
 #
 # \*BSD/MacOS doesn't support %N but after installing GNU
 # coreutils...
 #DATEFORMAT='gdate +%s.%N'
 #
 # Readable GMT
 #DATEFORMAT='date -u +%FT%H-%M-%S%z'
 #
 # Readable Local time
 DATEFORMAT='date +%FT%H-%M-%S%z'



```



---


### Running ast\_coredumper for crashes

As you can see, there are lots of options but if the core file is simply named `core` in your current directory, running `/var/lib/asterisk/scripts/ast_coredumper core` will usually be sufficient.




---

  
  


```

$ sudo /var/lib/asterisk/scripts/ast\_coredumper core
Processing core
Creating core-thread1.txt
Creating core-brief.txt
Creating core-info.txt
Creating core-full.txt
Creating core-locks.txt
$ 

```



---


Unless you've compiled Asterisk with the `DEBUG_THREADS` compiler flag (see below), the locks.txt file will be empty.

Many system administrators use the sysctl `kernel.core_pattern` parameter to control where core files are dumped and what they are named.




---

  
  


```

$ sysctl -n kernel.core\_pattern
/tmp/core-%e-%t
$ ls -al /tmp/core-asterisk\*
-rw-------. 1 root root 173936640 Jun 16 07:44 /tmp/core-asterisk-1497620664.32259
$ sudo /var/lib/asterisk/scripts/ast\_coredumper /tmp/core-asterisk-1497620664.32259 
Processing /tmp/core-asterisk-1497620664.32259
Creating /tmp/core-asterisk-1497620664.32259-thread1.txt
Creating /tmp/core-asterisk-1497620664.32259-brief.txt
Creating /tmp/core-asterisk-1497620664.32259-info.txt
Creating /tmp/core-asterisk-1497620664.32259-full.txt
Creating /tmp/core-asterisk-1497620664.32259-locks.txt
 

```



---


You'll notice that the output file names include the full core file name.

If the `/etc/asterisk/ast_debug_tools.conf` file contained a `COREDUMPS` entry that would have matched the core file name in /tmp, then you don't even have to supply a path.




---

  
  


```

$ sudo /var/lib/asterisk/scripts/ast\_coredumper
Processing /tmp/core-asterisk-1497620664.32259
Creating /tmp/core-asterisk-1497620664.32259-thread1.txt
Creating /tmp/core-asterisk-1497620664.32259-brief.txt
Creating /tmp/core-asterisk-1497620664.32259-info.txt
Creating /tmp/core-asterisk-1497620664.32259-full.txt
Creating /tmp/core-asterisk-1497620664.32259-locks.txt

```



---


 

By default, ast\_coredumper also processes existing core files it detects.  You can suppress that using the `--no-default-search` option and supplying a path directly to a coredump. 




---

  
  


```

$ sudo /var/lib/asterisk/scripts/ast\_coredumper --no-default-search /tmp/core-asterisk-1497620664.32259
Processing /tmp/core-asterisk-1497620664.32259
Creating /tmp/core-asterisk-1497620664.32259-thread1.txt
Creating /tmp/core-asterisk-1497620664.32259-brief.txt
Creating /tmp/core-asterisk-1497620664.32259-info.txt
Creating /tmp/core-asterisk-1497620664.32259-full.txt
Creating /tmp/core-asterisk-1497620664.32259-locks.txt



```



---


### Running ast\_coredumper for deadlocks, taskprocessor backups, etc.

When collecting information about a deadlock or taskprocessor backups, it is useful to have additional information about the threads involved. We can generate this information by attaching to a running Asterisk process and gathering that information. Follow the steps below to collect debug that will be useful to Asterisk developers.

If you can easily reproduce the deadlock, in the Compiler Flags menu of menuselect you should enable **DEBUG\_THREADS**, **MALLOC\_DEBUG**, **DONT\_OPTIMIZE**. Then, you need to recompile, re-install, and restart Asterisk before following the steps below.  **DEBUG\_THREADS** is very resource intensive and can seriously impact performance so you should only use it if you can reproduce the issue quickly.  Otherwise, **DONT\_OPTIMIZE** is the only option you really need. 

When you suspect asterisk is deadlocked or you start seeing "task processor queue reached..." messages, you can use ast\_coredumper to dump the currently running asterisk instance.


---

  
  


```

$ sudo /var/lib/asterisk/scripts/ast\_coredumper --running --no-default-search
WARNING: Taking a core dump of the running asterisk instance will suspend call processing while the dump is saved. Do you wish to continue? (y/N) y
Dumping running asterisk process to /tmp/core-asterisk-running-2017-06-16T09-56-53-0600
Processing /tmp/core-asterisk-running-2017-06-16T09-56-53-0600
Creating /tmp/core-asterisk-running-2017-06-16T09-56-53-0600-thread1.txt
Creating /tmp/core-asterisk-running-2017-06-16T09-56-53-0600-brief.txt
Creating /tmp/core-asterisk-running-2017-06-16T09-56-53-0600-info.txt
Creating /tmp/core-asterisk-running-2017-06-16T09-56-53-0600-full.txt
Creating /tmp/core-asterisk-running-2017-06-16T09-56-53-0600-locks.txt



```



---


You can suppress the "continue" prompt by specifying `--RUNNING` instead of `--running`.

If Asterisk is truly deadlocked and you compiled with `DEBUG_THREADS`, the locks.txt file should now contain a table of locks including who's waiting and who's holding.

Reporting crashes and deadlocks
-------------------------------

 




---

**WARNING!:**   
Coredump files may contain sensitive information you might not wish to expose. You should scrub them before attaching them to an issue.

  



---


 

Subject to the warning above, you can attach the text files directly to an Asterisk issue.  Occasionally, we'll ask you to run `ast_coredumper` again with additional options that will create a tarball that includes the Asterisk binaries and the the raw coredump.  The command for that is `/var/lib/asterisk/scripts/ast_coredumper --tarball-coredumps --no-default-search <path_to_coredump>`.  We'll give you instructions on how to get the file to us securely.

 

