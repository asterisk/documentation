---
search:
  boost: 0.5
title: SMS
---

# SMS()

### Synopsis

Communicates with SMS service centres and SMS capable analogue phones.

### Description

SMS handles exchange of SMS data with a call to/from SMS capable phone or SMS PSTN service center. Can send and/or receive SMS messages. Works to ETSI ES 201 912; compatible with BT SMS PSTN service in UK and Telecom Italia in Italy.<br>

Typical usage is to use to handle calls from the SMS service centre CLI, or to set up a call using 'outgoing' or manager interface to connect service centre to SMS().<br>

"Messages are processed as per text file message queues. smsq (a separate software) is a command to generate message queues and send messages.<br>


/// note
The protocol has tight delay bounds. Please use short frames and disable/keep short the jitter buffer on the ATA to make sure that respones (ACK etc.) are received in time.
///


### Syntax


```

SMS(name,[options,[addr,[body]]])
```
##### Arguments


* `name` - The name of the queue used in */var/spool/asterisk/sms*<br>

* `options`

    * `a` - Answer, i.e. send initial FSK packet.<br>


    * `s` - Act as service centre talking to a phone.<br>


    * `t` - Use protocol 2 (default used is protocol 1).<br>


    * `p` - Set the initial delay to N ms (default is '300'). addr and body are a deprecated format to send messages out.<br>


    * `r` - Set the Status Report Request (SRR) bit.<br>


    * `o` - The body should be coded as octets not 7-bit symbols.<br>


    * `n` - Do not log any SMS content to log file (privacy).<br>


* `addr`

* `body`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 