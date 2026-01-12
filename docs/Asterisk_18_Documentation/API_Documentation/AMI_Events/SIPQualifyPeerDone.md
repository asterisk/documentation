---
search:
  boost: 0.5
title: SIPQualifyPeerDone
---

# SIPQualifyPeerDone

### Synopsis

Raised when SIPQualifyPeer has finished qualifying the specified peer.

### Syntax


```


Event: SIPQualifyPeerDone
Peer: <value>
ActionID: <value>

```
##### Arguments


* `Peer` - The name of the peer.<br>

* `ActionID` - This is only included if an ActionID Header was sent with the action request, in which case it will be that ActionID.<br>

### Class

CALL
### See Also

* [AMI Actions SIPqualifypeer](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/SIPqualifypeer)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 