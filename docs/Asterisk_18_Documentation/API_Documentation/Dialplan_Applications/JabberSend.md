---
search:
  boost: 0.5
title: JabberSend
---

# JabberSend() - [res_xmpp\]

### Synopsis

Sends an XMPP message to a buddy.

### Description

Sends the content of _message_ as text message from the given _account_ to the buddy identified by _jid_<br>

The example below sends "Hello world" to _bob@domain.com_ as an XMPP message from the account _asterisk_, configured in xmpp.conf.<br>

``` title="Example: Send 'Hello world' to Bob"

same => n,JabberSend(asterisk,bob@domain.com,Hello world)


```

### Syntax


```

JabberSend(account,jid,message)
```
##### Arguments


* `account` - The local named account to listen on (specified in xmpp.conf)<br>

* `jid` - Jabber ID of the buddy to send the message to. It can be a bare JID (username@domain) or a full JID (username@domain/resource).<br>

* `message` - The message to send.<br>

### See Also

* [Dialplan Functions JABBER_STATUS_res_xmpp](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/JABBER_STATUS_res_xmpp)
* [Dialplan Functions JABBER_RECEIVE_res_xmpp](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/JABBER_RECEIVE_res_xmpp)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 