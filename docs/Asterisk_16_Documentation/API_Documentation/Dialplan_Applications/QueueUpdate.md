---
search:
  boost: 0.5
title: QueueUpdate
---

# QueueUpdate()

### Synopsis

Writes to the queue_log file for outbound calls and updates Realtime Data. Is used at h extension to be able to have all the parameters.

### Description

Allows you to write Outbound events into the queue log.<br>

``` title="Example: Write outbound event into queue log"

exten => h,1,QueueUpdate(${QUEUE}, ${UNIQUEID}, ${AGENT}, ${DIALSTATUS}, ${ANSWEREDTIME}, ${DIALEDTIME} | ${DIALEDNUMBER})


```

### Syntax


```

QueueUpdate(queuename,uniqueid,agent,status,talktime,[params])
```
##### Arguments


* `queuename`

* `uniqueid`

* `agent`

* `status`

* `talktime`

* `params`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 