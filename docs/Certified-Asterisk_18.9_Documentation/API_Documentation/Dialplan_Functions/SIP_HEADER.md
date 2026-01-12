---
search:
  boost: 0.5
title: SIP_HEADER
---

# SIP_HEADER()

### Synopsis

Gets the specified SIP header from an incoming INVITE message.

### Description

Since there are several headers (such as Via) which can occur multiple times, SIP\_HEADER takes an optional second argument to specify which header with that name to retrieve. Headers start at offset '1'.<br>

This function does not access headers from the REFER message if the call was transferred. To obtain the REFER headers, set the dialplan variable **GET\_TRANSFERRER\_DATA** to the prefix of the headers of the REFER message that you need to access; for example, 'X-' to get all headers starting with 'X-'. The variable must be set before a call to the application that starts the channel that may eventually transfer back into the dialplan, and must be inherited by that channel, so prefix it with the '\_' or '\_\_' when setting (or set it in the pre-dial handler executed on the new channel). To get all headers of the REFER message, set the value to '*'. Headers are returned in the form of a dialplan hash TRANSFER\_DATA, and can be accessed with the functions **HASHKEYS(TRANSFER\_DATA)** and, e. g., **HASH(TRANSFER\_DATA,X-That-Special-Header)**.<br>

Please also note that contents of the SDP (an attachment to the SIP request) can't be accessed with this function.<br>


### Syntax


```

SIP_HEADER(name,number)
```
##### Arguments


* `name`

* `number` - If not specified, defaults to '1'.<br>

### See Also

* [Dialplan Functions SIP_HEADERS](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/SIP_HEADERS)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 