---
search:
  boost: 0.5
title: JABBER_STATUS
---

# JABBER_STATUS() - [res_xmpp\]

### Synopsis

Retrieves a buddy's status.

### Description

Retrieves the numeric status associated with the buddy identified by _jid_. If the buddy does not exist in the buddylist, returns 7.<br>

Status will be 1-7.<br>

1=Online, 2=Chatty, 3=Away, 4=XAway, 5=DND, 6=Offline<br>

If not in roster variable will be set to 7.<br>

Example: $\{JABBER\_STATUS(asterisk,bob@domain.com)\} returns 1 if _bob@domain.com_ is online. _asterisk_ is the associated XMPP account configured in xmpp.conf.<br>


### Syntax


```

JABBER_STATUS(account,jid)
```
##### Arguments


* `account` - The local named account to listen on (specified in xmpp.conf)<br>

* `jid` - Jabber ID of the buddy to receive message from. It can be a bare JID (username@domain) or a full JID (username@domain/resource).<br>

### See Also

* [Dialplan Functions JABBER_RECEIVE_res_xmpp](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/JABBER_RECEIVE_res_xmpp)
* [Dialplan Applications JabberSend_res_xmpp](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/JabberSend_res_xmpp)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 