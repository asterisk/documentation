---
search:
  boost: 0.5
title: Signal
---

# Signal()

### Synopsis

Sends a signal to any waiting channels.

### Description

Sends a named signal to any channels that may be waiting for one. Acts as a producer in a simple message queue.<br>


* `SIGNALSTATUS`

    * `SUCCESS` - Signal was successfully sent to at least one listener for processing.

    * `FAILURE` - Signal could not be sent or nobody was listening for this signal.
``` title="Example: Send a signal named workdone"

same => n,Signal(workdone,Work has completed)


```

### Syntax


```

Signal(signalname,[payload])
```
##### Arguments


* `signalname` - Name of signal to send.<br>

* `payload` - Payload data to deliver.<br>

### See Also

* [Dialplan Applications WaitForSignal](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/WaitForSignal)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 