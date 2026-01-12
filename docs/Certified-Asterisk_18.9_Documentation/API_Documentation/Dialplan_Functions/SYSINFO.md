---
search:
  boost: 0.5
title: SYSINFO
---

# SYSINFO()

### Synopsis

Returns system information specified by parameter.

### Description

Returns information from a given parameter.<br>


### Syntax


```

SYSINFO(parameter)
```
##### Arguments


* `parameter`

    * `loadavg` - System load average from past minute.<br>

    * `numcalls` - Number of active calls currently in progress.<br>

    * `uptime` - System uptime in hours.<br>

        /// note
This parameter is dependant upon operating system.
///


    * `totalram` - Total usable main memory size in KiB.<br>

        /// note
This parameter is dependant upon operating system.
///


    * `freeram` - Available memory size in KiB.<br>

        /// note
This parameter is dependant upon operating system.
///


    * `bufferram` - Memory used by buffers in KiB.<br>

        /// note
This parameter is dependant upon operating system.
///


    * `totalswap` - Total swap space still available in KiB.<br>

        /// note
This parameter is dependant upon operating system.
///


    * `freeswap` - Free swap space still available in KiB.<br>

        /// note
This parameter is dependant upon operating system.
///


    * `numprocs` - Number of current processes.<br>

        /// note
This parameter is dependant upon operating system.
///



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 