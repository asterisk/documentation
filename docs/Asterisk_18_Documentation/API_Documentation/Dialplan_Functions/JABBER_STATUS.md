---
search:
  boost: 0.5
title: JABBER_STATUS
---

# JABBER_STATUS() - [res_xmpp\]

### Synopsis

Retrieves a buddy's status.

### Description

Retrieves the numeric status associated with the buddy identified by _jid_. The return value will be one of the following.<br>


* `1` - Online<br>

* `2` - Chatty<br>

* `3` - Away<br>

* `4` - Extended Away<br>

* `5` - Do Not Disturb<br>

* `6` - Offline<br>

* `7` - Not In Roster<br>

### Syntax


```

JABBER_STATUS(account,jid)
```
##### Arguments


* `account` - The local named account to listen on (specified in xmpp.conf)<br>

* `jid` - Jabber ID of the buddy to receive message from. It can be a bare JID (username@domain) or a full JID (username@domain/resource).<br>

### See Also

* [Dialplan Functions JABBER_RECEIVE_res_xmpp](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/JABBER_RECEIVE_res_xmpp)
* [Dialplan Applications JabberSend_res_xmpp](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/JabberSend_res_xmpp)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 