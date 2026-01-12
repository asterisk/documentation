---
search:
  boost: 0.5
title: PeerStatus
---

# PeerStatus

### Synopsis

Raised when the state of a peer changes.

### Syntax


```


Event: PeerStatus
ChannelType: <value>
Peer: <value>
PeerStatus: <value>
Cause: <value>
Address: <value>
Port: <value>
Time: <value>

```
##### Arguments


* `ChannelType` - The channel technology of the peer.<br>

* `Peer` - The name of the peer (including channel technology).<br>

* `PeerStatus` - New status of the peer.<br>

    * `Unknown`

    * `Registered`

    * `Unregistered`

    * `Rejected`

    * `Lagged`

* `Cause` - The reason the status has changed.<br>

* `Address` - New address of the peer.<br>

* `Port` - New port for the peer.<br>

* `Time` - Time it takes to reach the peer and receive a response.<br>

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 