---
title: Logging Configuration
pageid: 28315599
---

Asterisk Log File Configuration
===============================

General purpose [logging facilities](/Operation/Logging) in Asterisk can be configured in the *[logger.conf](http://svnview.digium.com/svn/asterisk/trunk/configs/logger.conf.sample?view=markup)* file. Within this file one is able to configure Asterisk to log messages to files and/or a syslog and even to the Asterisk console.  Note, the sections and descriptions listed below are meant to be informational and act as a guide (a "how to") when configuring logging in Asterisk.  Options with stated defaults don't have to be explicitly set as they will simply default to a designated value.

General Section:
----------------




---

  
  


```

[general]
; Customize the display of debug message time stamps
; this example is the ISO 8601 date format (yyyy-mm-dd HH:MM:SS)
;
; see strftime(3) Linux manual for format specifiers. Note that there is
; also a fractional second parameter which may be used in this field. Use
; %1q for tenths, %2q for hundredths, etc.
;
dateformat = %F %T.%3q ; ISO 8601 date format with milliseconds

; Write callids to log messages (defaults to yes)
use\_callids = yes

; Append the hostname to the name of the log files (defaults to no)
appendhostname = no

; Log queue events to a file (defaults to yes)
queue\_log = yes

; Always log queue events to a file, even when a realtime backend is
; present (defaults to no).
queue\_log\_to\_file = no

; Set the queue\_log filename (defaults to queue\_log)
queue\_log\_name = queue\_log

; When using realtime for the queue log, use GMT for the timestamp
; instead of localtime. (defaults to no)
queue\_log\_realtime\_use\_gmt = no

; Log rotation strategy (defaults to sequential):
; none: Do not perform any log rotation at all. You should make
; very sure to set up some external log rotate mechanism
; as the asterisk logs can get very large, very quickly.
; sequential: Rename archived logs in order, such that the newest
; has the highest sequence number. When
; exec\_after\_rotate is set, ${filename} will specify
; the new archived logfile.
; rotate: Rotate all the old files, such that the oldest has the
; highest sequence number (this is the expected behavior
; for Unix administrators). When exec\_after\_rotate is
; set, ${filename} will specify the original root filename.
; timestamp: Rename the logfiles using a timestamp instead of a
; sequence number when "logger rotate" is executed.
; When exec\_after\_rotate is set, ${filename} will
; specify the new archived logfile.
rotatestrategy = rotate

; Run a system command after rotating the files. This is mainly
; useful for rotatestrategy=rotate. The example allows the last
; two archive files to remain uncompressed, but after that point,
; they are compressed on disk.
exec\_after\_rotate=gzip -9 ${filename}.2



```



---


Log Files Section:
------------------




---

  
  


```

[logfiles]
; File names can either be relative to the standard Asterisk log directory (see "astlogdir" in
; asterisk.conf), or absolute paths that begin with '/'.
;
; A few file names have been reserved and are considered special, thus cannot be used and will
; not be considered as a regular file name. These include the following:
;
; syslog - logs to syslog facility
; console - logs messages to the Asterisk root console.
;
; For each file name given a comma separated list of logging "level" types should be specified
; and include at least one of the following (in no particular order):
; debug
; notice
; warning
; error
; dtmf
; fax
; security
; verbose(<level>)
;
; The "verbose" value can take an optional integer argument that indicates the maximum level
; of verbosity to log at. Verbose messages with higher levels than the indicated level will
; not be logged to the file. If a verbose level is not given, verbose messages are logged
; based upon the current level set for the root console.
;
; The special character "\*" can also be specified and represents all levels, even dynamic
; levels registered by modules after the logger has been initialized. This means that loading
; and unloading modules that create and remove dynamic logging levels will result in these
; levels being included on filenames that have a level name of "\*", without any need to
; perform a "logger reload" or similar operation.
;
; Note, there is no value in specifying both "\*" and specific level types for a file name.
; The "\*" level means ALL levels. The only exception is if you need to specify a specific
; verbose level. e.g, "verbose(3),\*".
;
; It is highly recommended that you DO NOT turn on debug mode when running a production system
; unless you are in the process of debugging a specific issue. Debug mode outputs a LOT of
; extra messages and information that can and do fill up log files quickly. Most of these
; messages are hard to interpret without an understanding of the underlying code. Do NOT report
; debug messages as code issues, unless you have a specific issue that you are attempting to debug.
; They are messages for just that -- debugging -- and do not rise to the level of something that
; merit your attention as an Asterisk administrator. 

; output notices, warnings and errors to the console
console => notice,warning,error

; output security messages to the file named "security"
security => security

; output notices, warnings and errors to the the file named "messages"
messages => notice,warning,error

; output notices, warnings, errors, verbose, dtmf, and fax to file name "full"
full => notice,warning,error,verbose,dtmf,fax

; output notices, warning, and errors to the syslog facility
syslog.local0 => notice,warning,error



```



---


