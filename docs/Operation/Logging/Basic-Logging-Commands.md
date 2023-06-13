---
title: Basic Logging Commands
pageid: 28315847
---

Here is a selection of basic logging commands to get you started with manipulating log settings at the Asterisk CLI.

##### core set verbose

Set the level of verbose messages to be displayed on the console. “0” or "off" means no verbose messages should be displayed. The silent option means the command does not report what happened to the verbose level. Equivalent to -v[v[...]] on start up.


```
Usage: core set verbose [atleast] <level> [silent]
```
##### core set debug

Set the level of debug messages to be displayed or set a module name to display debug messages from. "0" or "off" means no messages should be displayed. Equivalent to -d[d[...]] on start up.


```
Usage: core set debug [atleast] <level> [module]
```
##### logger show channels

List configured logger channels.


```
Usage: logger show channels
```
##### logger rotate

Rotates and Reopens the log files.


```
Usage: logger rotate
```
##### logger reload

Reloads the logger subsystem state. Use after restarting syslogd(8) if using syslog logging.


```
Usage: logger reload [<alt-conf>]
```
##### core show settings

Show miscellaneous core system settings.  Along with showing other various settings, issuing this command will show the current debug level as well as the root and current console verbosity levels.  These log settings can be found under the "PBX Core Settings" section after executing the command.


```
Usage: core show settings
```
