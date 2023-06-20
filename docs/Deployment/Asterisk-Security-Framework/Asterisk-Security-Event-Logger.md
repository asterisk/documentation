---
title: Asterisk Security Event Logger
pageid: 5243080
---

In addition to the infrastructure for generating the security events, an event logger module (that can consume these events) is also available. Asterisk, through its [Logging Configuration](/Configuration/Core-Configuration/Logging-Configuration) supports multiple types of dynamic logging levels.  The security logging module takes advantage of this and creates a custom "security" logging level when loaded.  To enable logging of security events simply add a file, specifying the "security" logging level, to the logger.conf.  For example adding the following will log security events to a file named "security\_log":




---

  
  


```

security\_log => security

```



---


The content of the log file is well defined and is in an easily interpretable [format](/Security-Log-File-Format) allowing for external scripts to read and act upon.

