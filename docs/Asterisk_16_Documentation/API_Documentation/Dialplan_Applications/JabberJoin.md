---
search:
  boost: 0.5
title: JabberJoin
---

# JabberJoin() - [res_xmpp\]

### Synopsis

Join a chat room

### Description

Allows Asterisk to join a chat room.<br>


### Syntax


```

JabberJoin(Jabber,RoomJID,[Nickname])
```
##### Arguments


* `Jabber` - Client or transport Asterisk uses to connect to Jabber.<br>

* `RoomJID` - XMPP/Jabber JID (Name) of chat room.<br>

* `Nickname` - The nickname Asterisk will use in the chat room.<br>

    /// note
If a different nickname is supplied to an already joined room, the old nick will be changed to the new one.
///



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 