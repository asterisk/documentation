---
search:
  boost: 0.5
title: SMDI_MSG
---

# SMDI_MSG()

### Synopsis

Retrieve details about an SMDI message.

### Description

This function is used to access details of an SMDI message that was pulled from the incoming SMDI message queue using the SMDI\_MSG\_RETRIEVE() function.<br>


### Syntax


```

SMDI_MSG(message_id,component)
```
##### Arguments


* `message_id`

* `component` - Valid message components are:<br>

    * `number` - The message desk number<br>

    * `terminal` - The message desk terminal<br>

    * `station` - The forwarding station<br>

    * `callerid` - The callerID of the calling party that was forwarded<br>

    * `type` - The call type. The value here is the exact character that came in on the SMDI link. Typically, example values are:<br>
Options:<br>

        * `D` - Direct Calls<br>

        * `A` - Forward All Calls<br>

        * `B` - Forward Busy Calls<br>

        * `N` - Forward No Answer Calls<br>

### See Also

* [Dialplan Functions SMDI_MSG_RETRIEVE](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/SMDI_MSG_RETRIEVE)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 