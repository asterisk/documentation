---
search:
  boost: 0.5
title: MESSAGE_DATA
---

# MESSAGE_DATA()

### Synopsis

Read or write custom data attached to a message.

### Description

This function will read from or write a value to a text message. It is used both to read the data out of an incoming message, as well as modify a message that will be sent outbound.<br>


/// note
If you want to set an outbound message to carry data in the current message, do Set(MESSAGE\_DATA( _key_)=$\{MESSAGE\_DATA(_key_)\}).
///


### Syntax


```

MESSAGE_DATA(argument)
```
##### Arguments


* `argument` - Field of the message to get or set.<br>

### See Also

* [Dialplan Applications MessageSend](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/MessageSend)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 