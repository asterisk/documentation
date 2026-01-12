---
search:
  boost: 0.5
title: JABBER_RECEIVE
---

# JABBER_RECEIVE() - [res_xmpp\]

### Synopsis

Reads XMPP messages.

### Description

Receives a text message on the given _account_ from the buddy identified by _jid_ and returns the contents.<br>

The example below returns an XMPP message sent from _bob@domain.com_ (or nothing in case of a time out), to the _asterisk_ XMPP account configured in xmpp.conf.<br>

``` title="Example: Receive a message"

same => n,Set(msg=${JABBER_RECEIVE(asterisk,bob@domain.com)})


```

### Syntax


```

JABBER_RECEIVE(account,jid,timeout)
```
##### Arguments


* `account` - The local named account to listen on (specified in xmpp.conf)<br>

* `jid` - Jabber ID of the buddy to receive message from. It can be a bare JID (username@domain) or a full JID (username@domain/resource).<br>

* `timeout` - In seconds, defaults to '20'.<br>

### See Also

* [Dialplan Functions JABBER_STATUS_res_xmpp](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/JABBER_STATUS_res_xmpp)
* [Dialplan Applications JabberSend_res_xmpp](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/JabberSend_res_xmpp)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 