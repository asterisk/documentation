---
search:
  boost: 0.5
title: MESSAGE
---

# MESSAGE()

### Synopsis

Create a message or read fields from a message.

### Description

This function will read from or write a value to a text message. It is used both to read the data out of an incoming message, as well as modify or create a message that will be sent outbound.<br>


### Syntax


```

MESSAGE(argument)
```
##### Arguments


* `argument` - Field of the message to get or set.<br>

    * `to` - When processing an incoming message, this will be set to the destination listed as the recipient of the message that was received by Asterisk.<br>
<br>
For an outgoing message, this will set the To header in the outgoing SIP message. This may be overridden by the "to" parameter of MessageSend.<br>

    * `from` - When processing an incoming message, this will be set to the source of the message.<br>
<br>
For an outgoing message, this will set the From header in the outgoing SIP message. This may be overridden by the "from" parameter of MessageSend.<br>

    * `custom_data` - Write-only. Mark or unmark all message headers for an outgoing message. The following values can be set:<br>

        * `mark_all_outbound` - Mark all headers for an outgoing message.<br>

        * `clear_all_outbound` - Unmark all headers for an outgoing message.<br>

    * `body` - Read/Write. The message body. When processing an incoming message, this includes the body of the message that Asterisk received. When MessageSend() is executed, the contents of this field are used as the body of the outgoing message. The body will always be UTF-8.<br>

### See Also

* [Dialplan Applications MessageSend](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MessageSend)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 