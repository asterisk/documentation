---
search:
  boost: 0.5
title: JabberStatus
---

# JabberStatus() - [res_xmpp\]

### Synopsis

Retrieve the status of a jabber list member

### Description

This application is deprecated. Please use the JABBER\_STATUS() function instead.<br>

Retrieves the numeric status associated with the specified buddy _JID_. The return value in the _Variable_will be one of the following.<br>


* `1` - Online.<br>

* `2` - Chatty.<br>

* `3` - Away.<br>

* `4` - Extended Away.<br>

* `5` - Do Not Disturb.<br>

* `6` - Offline.<br>

* `7` - Not In Roster.<br>

### Syntax


```

JabberStatus(Jabber,JID,Variable)
```
##### Arguments


* `Jabber` - Client or transport Asterisk users to connect to Jabber.<br>

* `JID` - XMPP/Jabber JID (Name) of recipient.<br>

* `Variable` - Variable to store the status of requested user.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 