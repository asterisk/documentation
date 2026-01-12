---
search:
  boost: 0.5
title: LogChannel
---

# LogChannel

### Synopsis

Raised when a logging channel is re-enabled after a reload operation.

### Syntax


```


Event: LogChannel
Channel: <value>

```
##### Arguments


* `Channel` - The name of the logging channel.<br>

### Class

SYSTEM
### Synopsis

Raised when a logging channel is disabled.

### Syntax


```


Event: LogChannel
Channel: <value>
Enabled: <value>
Reason: <value>

```
##### Arguments


* `Channel` - The name of the logging channel.<br>

* `Enabled`

* `Reason`

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 