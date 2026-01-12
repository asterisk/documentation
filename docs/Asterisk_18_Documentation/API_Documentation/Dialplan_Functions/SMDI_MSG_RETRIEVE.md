---
search:
  boost: 0.5
title: SMDI_MSG_RETRIEVE
---

# SMDI_MSG_RETRIEVE()

### Synopsis

Retrieve an SMDI message.

### Description

This function is used to retrieve an incoming SMDI message. It returns an ID which can be used with the SMDI\_MSG() function to access details of the message. Note that this is a destructive function in the sense that once an SMDI message is retrieved using this function, it is no longer in the global SMDI message queue, and can not be accessed by any other Asterisk channels. The timeout for this function is optional, and the default is 3 seconds. When providing a timeout, it should be in milliseconds.<br>

The default search is done on the forwarding station ID. However, if you set one of the search key options in the options field, you can change this behavior.<br>


### Syntax


```

SMDI_MSG_RETRIEVE(smdi port,search key,timeout,options)
```
##### Arguments


* `smdi port`

* `search key`

* `timeout`

* `options`

    * `t` - Instead of searching on the forwarding station, search on the message desk terminal.<br>

    * `n` - Instead of searching on the forwarding station, search on the message desk number.<br>

### See Also

* [Dialplan Functions SMDI_MSG](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/SMDI_MSG)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 