---
search:
  boost: 0.5
title: FAXStats
---

# FAXStats

### Synopsis

Raised in response to FAXStats manager command

### Syntax


```


    Event: FAXStats
    [ActionID:] <value>
    CurrentSessions: <value>
    ReservedSessions: <value>
    TransmitAttempts: <value>
    ReceiveAttempts: <value>
    CompletedFAXes: <value>
    FailedFAXes: <value>

```
##### Arguments


* `ActionID`

* `CurrentSessions` - Number of active FAX sessions<br>

* `ReservedSessions` - Number of reserved FAX sessions<br>

* `TransmitAttempts` - Total FAX sessions for which Asterisk is/was the transmitter<br>

* `ReceiveAttempts` - Total FAX sessions for which Asterisk is/was the recipient<br>

* `CompletedFAXes` - Total FAX sessions which have been completed successfully<br>

* `FailedFAXes` - Total FAX sessions which failed to complete successfully<br>

### Class

REPORTING

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 