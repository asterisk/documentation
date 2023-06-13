---
title: MALLOC_DEBUG Compiler Flag
pageid: 28315432
---

MALLOC\_DEBUG enhancements can be used as a poor-man's  if Valgrind performance makes the PC unusable due to resource consumption.

Don't attempt to use Asterisk compiled with MALLOC\_DEBUG and run Valgrind at the same time, as they will compete and render the findings invalid for either tool.

Gathering output
----------------

For this output to be useful make sure to upgrade Asterisk versions 1.8.20, 11.2.0 or above as they include important enhancements to MALLOC\_DEBUG

 

1. Run menuselect and in the Compiler Options, enable MALLOC\_DEBUG. A bug marshal may also ask you to enable additional compiler flags depending upon the nature of the issue.
2. Rebuild and install Asterisk
3. Run Asterisk and reproduce the issue.
4. Collect the /var/log/asterisk/mmlog (which will be generated only if you successfully compiled with the MALLOC\_DEBUG flag)
5. Attach the mmlog file as mmlog.txt to the issue in our issue tracker.

Commands provided
-----------------

Compiling with this flag results in several commands being made available for memory debugging. Below are the usage and summaries from "core show help" for each command in Asterisk 12.

* memory show summary

Click to show usage...Usage: memory show summary [<file>]
 Summarizes heap memory allocations by file, or optionally
 by line, if a file is specified.
* memory show allocations

Click to show usage...Usage: memory show allocations [<file>|anomalies]
 Dumps a list of segments of allocated memory.
 Defaults to listing all memory allocations.
 <file> - Restricts output to memory allocated by the file.
 anomalies - Only check for fence violations.
* memory atexit list

Click to show usage...Usage: memory atexit list {on|off}
 Enable dumping a list of still allocated memory segments at exit.
* memory atexit summary

Click to show usage...Usage: memory atexit summary {off|byline|byfunc|byfile}
 Summary of still allocated memory segments at exit options.
 off - Disable at exit summary.
 byline - Enable at exit summary by file line number.
 byfunc - Enable at exit summary by function name.
 byfile - Enable at exit summary by file.
 Note: byline, byfunc, and byfile are cumulative enables.
* memory backtrace

Click to show usage...Usage: memory backtrace {on|off}
 Enable dumping an allocation backtrace with memory diagnostics.
 Note that saving the backtrace data for each allocation
 can be CPU intensive.
