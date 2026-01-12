---
search:
  boost: 0.5
title: SendText
---

# SendText

### Synopsis

Sends a text message to channel. A content type can be optionally specified. If not set it is set to an empty string allowing a custom handler to default it as it sees fit.

### Description

Sends A Text Message to a channel while in a call.<br>


### Syntax


```


Action: SendText
ActionID: <value>
Channel: <value>
Message: <value>
[Content-Type: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel to send message to.<br>

* `Message` - Message to send.<br>

* `Content-Type` - The type of content in the message<br>

### See Also

* [Dialplan Applications SendText](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SendText)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 