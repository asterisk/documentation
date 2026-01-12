---
search:
  boost: 0.5
title: JabberSendGroup
---

# JabberSendGroup() - [res_xmpp\]

### Synopsis

Send a Jabber Message to a specified chat room

### Description

Allows user to send a message to a chat room via XMPP.<br>


/// note
To be able to send messages to a chat room, a user must have previously joined it. Use the _JabberJoin_ function to do so.
///


### Syntax


```

JabberSendGroup(Jabber,RoomJID,Message,[Nickname])
```
##### Arguments


* `Jabber` - Client or transport Asterisk uses to connect to Jabber.<br>

* `RoomJID` - XMPP/Jabber JID (Name) of chat room.<br>

* `Message` - Message to be sent to the chat room.<br>

* `Nickname` - The nickname Asterisk uses in the chat room.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 