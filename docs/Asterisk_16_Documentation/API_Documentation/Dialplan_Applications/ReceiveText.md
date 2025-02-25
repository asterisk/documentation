---
search:
  boost: 0.5
title: ReceiveText
---

# ReceiveText()

### Synopsis

Receive a Text Message on a channel.

### Since

16.24.0, 18.10.0, 19.2.0

### Description

Waits for _timeout_ seconds on the current channel to receive text.<br>

Result of transmission will be stored in the following variables:<br>


* `RECEIVETEXTMESSAGE` - The received text message.<br>

* `RECEIVETEXTSTATUS`

    * `SUCCESS` - Transmission succeeded.

    * `FAILURE` - Transmission failed or timed out.
``` title="Example: Receive message on channel"

same => n,ReceiveText()
same => n,NoOp(${RECEIVETEXTMESSAGE})


```

### Syntax


```

ReceiveText([timeout])
```
##### Arguments


* `timeout` - Time in seconds to wait for text. Default is 0 (forever).<br>

### See Also

* [Dialplan Applications SendText](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SendText)
* [Dialplan Applications SendImage](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SendImage)
* [Dialplan Applications SendURL](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SendURL)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 