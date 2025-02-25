---
search:
  boost: 0.5
title: AlarmReceiver
---

# AlarmReceiver()

### Synopsis

Provide support for receiving alarm reports from a burglar or fire alarm panel.

### Description

This application should be called whenever there is an alarm panel calling in to dump its events. The application will handshake with the alarm panel, and receive events, validate them, handshake them, and store them until the panel hangs up. Once the panel hangs up, the application will run the system command specified by the eventcmd setting in *alarmreceiver.conf* and pipe the events to the standard input of the application. The configuration file also contains settings for DTMF timing, and for the loudness of the acknowledgement tones.<br>


/// note
Few Ademco DTMF signalling formats are detected automatically: Contact ID, Express 4+1, Express 4+2, High Speed and Super Fast.
///

The application is affected by the following variables:<br>


* `ALARMRECEIVER_CALL_LIMIT` - Maximum call time, in milliseconds.<br>
If set, this variable causes application to exit after the specified time.<br>

* `ALARMRECEIVER_RETRIES_LIMIT` - Maximum number of retries per call.<br>
If set, this variable causes application to exit after the specified number of messages.<br>

### Syntax


```

AlarmReceiver()
```
##### Arguments

### See Also

* {{alarmreceiver.conf}}


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 