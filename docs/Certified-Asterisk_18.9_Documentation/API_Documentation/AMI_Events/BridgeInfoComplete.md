---
search:
  boost: 0.5
title: BridgeInfoComplete
---

# BridgeInfoComplete

### Synopsis

Information about a bridge.

### Syntax


```


Event: BridgeInfoComplete
BridgeUniqueid: <value>
BridgeType: <value>
BridgeTechnology: <value>
BridgeCreator: <value>
BridgeName: <value>
BridgeNumChannels: <value>
BridgeVideoSourceMode: <value>
BridgeVideoSource: <value>

```
##### Arguments


* `BridgeUniqueid`

* `BridgeType` - The type of bridge<br>

* `BridgeTechnology` - Technology in use by the bridge<br>

* `BridgeCreator` - Entity that created the bridge if applicable<br>

* `BridgeName` - Name used to refer to the bridge by its BridgeCreator if applicable<br>

* `BridgeNumChannels` - Number of channels in the bridge<br>

* `BridgeVideoSourceMode` - 
    * `none`

    * `talker`

    * `single`
The video source mode for the bridge.<br>

* `BridgeVideoSource` - If there is a video source for the bridge, the unique ID of the channel that is the video source.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 