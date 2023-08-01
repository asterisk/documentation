---
title: Collecting Debug Information
pageid: 4259941
---

Collecting Debug Information for the Asterisk Issue Tracker
===========================================================

This document will provide instructions on how to collect debugging logs from an Asterisk machine, for the purpose of helping bug marshals troubleshoot an issue on <https://github.com/asterisk/asterisk/issues>

If Asterisk has crashed or deadlocked, see [Getting a Backtrace](/Development/Debugging/Getting-a-Backtrace).

STEPS
=====

Configure Asterisk logging
--------------------------

**1.** Edit the logger.conf file to enable specific logger channels to output to your filesystem. The word "debug_log_123456" can be changed to anything you want, as that is the filename the logging will be written to.

Modify the file name "debug_log_123456" to reflect your [github.com/asterisk/asterisk/issues](https://github.com/asterisk/asterisk/issues) issue number.




---

  
logger.conf  

```
[logfiles]
debug_log_123456 => notice,warning,error,debug,verbose,dtmf

```



!!! tip Asterisk 13+
    In Asterisk 13 and later, you can dynamically create log channels from the CLI using the `logger add channel` command. For example, to create the log file above, you would enter:
[//]: # (end-tip)


  
  

```
logger add channel debug_log_123456 notice,warning,error,debug,verbose,dtmf

```

The new log channel persists until Asterisk is restarted, the logger module is reloaded, or the log files are rotated. If using this CLI command, do **not** reload/restart/rotate the log files in Step 2.



---


Configure verbosity levels and rotate logs
------------------------------------------

**2.** From the Asterisk CLI, set the verbose and debug levels for logging (this affects CLI and log output) and then restart the logger module:

```
*CLI> core set verbose 5
*CLI> core set debug 5
*CLI> module reload logger

```

Optionally, if you've used this file to record data previously, then rotate the logs:

```
*CLI> logger rotate

```

Enable channel tech or feature specific debug
---------------------------------------------

**2.1.** Depending on your issue and if a protocol level trace is requested, be sure to enable logging for the channel driver or other module.



| Module (version) | CLI Command |
| --- | --- |
| New PJSIP driver (12 or higher) | `pjsip set logger on` |
| SIP (1.6.0 or higher) | `sip set debug on` |
| SIP (1.4) | `sip set debug` |
| IAX2 (1.6.0 or higher) | `iax2 set debug on` |
| IAX2 (1.4) | `iax2 set debug` |
| CDR engine | `cdr set debug on` |

Issue reproduction and clean up
-------------------------------

**3.** Now that logging is configured, enabled and verbosity is turned up you should reproduce your issue.

**4.** Once finished, be sure to disable the extra debugging:

```
*CLI> core set verbose 0
*CLI> core set debug 0

```

**4.1.** Again, remember to disable any extra logging for channel drivers or features.

SIP (1.4 or higher)

```
*CLI> sip set debug off

```

IAX2 (1.4 or higher)

```
*CLI> iax2 set debug off

```

**5.** Disable logging to the filesystem. Edit the logger.conf file and comment out or delete the line you added in step 1. Using a semi-colon as the first character on the line will comment out the line.




---

  
logger.conf  

```
[logfiles]
;debug_log_123456 => notice,warning,error,debug,verbose,dtmf

```

Then reload the logger module (or restart Asterisk) as you did in step 2:

```
*CLI> module reload logger

```

Provide debug to the developers
-------------------------------

**6.** Upload the file located in /var/log/asterisk/debug_log_123456 to the issue tracker.




---

**WARNING!**
------------

- Do **NOT** post the output of your file as a comment. This clutters the issue and will only result in your comment being deleted.
- Attach the file with a .txt extension to make it easy for the developers to quickly open the file without downloading.


---


