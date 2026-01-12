---
search:
  boost: 0.5
title: WaitForSignal
---

# WaitForSignal()

### Synopsis

Waits for a named signal on a channel.

### Description

Waits for _signaltimeout_ seconds on the current channel to receive a signal with name _signalname_. Acts as a consumer in a simple message queue.<br>

Result of signal wait will be stored in the following variables:<br>


* `WAITFORSIGNALSTATUS`

    * `SIGNALED` - Signal was received.

    * `TIMEOUT` - Timed out waiting for signal.

    * `HANGUP` - Channel hung up before signal was received.

* `WAITFORSIGNALPAYLOAD` - Data payload attached to signal, if it exists<br>
``` title="Example: Wait for the workdone signal, indefinitely, and print out payload"

same => n,WaitForSignal(workdone)
same => n,NoOp(Received: ${WAITFORSIGNALPAYLOAD})


```

### Syntax


```

WaitForSignal(signalname,[signaltimeout])
```
##### Arguments


* `signalname` - Name of signal to send.<br>

* `signaltimeout` - Maximum time, in seconds, to wait for signal.<br>

### See Also

* [Dialplan Applications Signal](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Signal)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 