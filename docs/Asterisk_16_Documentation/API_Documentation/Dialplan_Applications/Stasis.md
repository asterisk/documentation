---
search:
  boost: 0.5
title: Stasis
---

# Stasis()

### Synopsis

Invoke an external Stasis application.

### Description

Invoke a Stasis application.<br>

This application will set the following channel variable upon completion:<br>


* `STASISSTATUS` - This indicates the status of the execution of the Stasis application.<br>

    * `SUCCESS` - The channel has exited Stasis without any failures in Stasis.

    * `FAILED` - A failure occurred when executing the Stasis The app registry is not instantiated; The app application. Some (not all) possible reasons for this: requested is not registered; The app requested is not active; Stasis couldn't send a start message.

### Syntax


```

Stasis(app_name,[args])
```
##### Arguments


* `app_name` - Name of the application to invoke.<br>

* `args` - Optional comma-delimited arguments for the application invocation.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 