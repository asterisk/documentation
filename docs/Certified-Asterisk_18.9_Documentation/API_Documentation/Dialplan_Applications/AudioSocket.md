---
search:
  boost: 0.5
title: AudioSocket
---

# AudioSocket()

### Synopsis

Transmit and receive audio between channel and TCP socket

### Description

Connects to the given TCP service, then transmits channel audio over that socket. In turn, audio is received from the socket and sent to the channel. Only audio frames will be transmitted.<br>

Protocol is specified at https://docs.asterisk.org/Configuration/Channel-Drivers/AudioSocket/<br>

This application does not automatically answer and should generally be preceeded by an application such as Answer() or Progress().<br>


### Syntax


```

AudioSocket(uuid,service)
```
##### Arguments


* `uuid` - UUID is the universally-unique identifier of the call for the audio socket service. This ID must conform to the string form of a standard UUID.<br>

* `service` - Service is the name or IP address and port number of the audio socket service to which this call should be connected. This should be in the form host:port, such as myserver:9019<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 