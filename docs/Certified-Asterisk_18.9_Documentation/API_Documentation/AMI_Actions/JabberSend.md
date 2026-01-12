---
search:
  boost: 0.5
title: JabberSend
---

# JabberSend - [res_xmpp\]

### Synopsis

Sends a message to a Jabber Client.

### Description

Sends a message to a Jabber Client.<br>


### Syntax


```


Action: JabberSend
ActionID: <value>
Jabber: <value>
JID: <value>
Message: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Jabber` - Client or transport Asterisk uses to connect to JABBER.<br>

* `JID` - XMPP/Jabber JID (Name) of recipient.<br>

* `Message` - Message to be sent to the buddy.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 