---
search:
  boost: 0.5
title: ExternalIVR
---

# ExternalIVR()

### Synopsis

Interfaces with an external IVR application.

### Description

Either forks a process to run given command or makes a socket to connect to given host and starts a generator on the channel. The generator's play list is controlled by the external application, which can add and clear entries via simple commands issued over its stdout. The external application will receive all DTMF events received on the channel, and notification if the channel is hung up. The received on the channel, and notification if the channel is hung up. The application will not be forcibly terminated when the channel is hung up. For more information see *doc/AST.pdf*.<br>


### Syntax


```

ExternalIVR(command|ivr://host([arg1,[arg2[,...]]]),[options])
```
##### Arguments


* `command|ivr://host`

    * `arg1`

    * `arg2[,arg2...]`

* `options`

    * `n` - Tells ExternalIVR() not to answer the channel.<br>


    * `i` - Tells ExternalIVR() not to send a hangup and exit when the channel receives a hangup, instead it sends an 'I' informative message meaning that the external application MUST hang up the call with an 'H' command.<br>


    * `d` - Tells ExternalIVR() to run on a channel that has been hung up and will not look for hangups. The external application must exit with an 'E' command.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 