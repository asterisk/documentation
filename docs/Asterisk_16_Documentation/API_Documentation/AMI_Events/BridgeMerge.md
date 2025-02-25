---
search:
  boost: 0.5
title: BridgeMerge
---

# BridgeMerge

### Synopsis

Raised when two bridges are merged.

### Syntax


```


    Event: BridgeMerge
    ToBridgeUniqueid: <value>
    ToBridgeType: <value>
    ToBridgeTechnology: <value>
    ToBridgeCreator: <value>
    ToBridgeName: <value>
    ToBridgeNumChannels: <value>
    ToBridgeVideoSourceMode: <value>
    [ToBridgeVideoSource:] <value>
    FromBridgeUniqueid: <value>
    FromBridgeType: <value>
    FromBridgeTechnology: <value>
    FromBridgeCreator: <value>
    FromBridgeName: <value>
    FromBridgeNumChannels: <value>
    FromBridgeVideoSourceMode: <value>
    [FromBridgeVideoSource:] <value>

```
##### Arguments


* `ToBridgeUniqueid`

* `ToBridgeType` - The type of bridge<br>

* `ToBridgeTechnology` - Technology in use by the bridge<br>

* `ToBridgeCreator` - Entity that created the bridge if applicable<br>

* `ToBridgeName` - Name used to refer to the bridge by its BridgeCreator if applicable<br>

* `ToBridgeNumChannels` - Number of channels in the bridge<br>

* `ToBridgeVideoSourceMode` - 
    * `none`

    * `talker`

    * `single`
The video source mode for the bridge.<br>

* `ToBridgeVideoSource` - If there is a video source for the bridge, the unique ID of the channel that is the video source.<br>

* `FromBridgeUniqueid`

* `FromBridgeType` - The type of bridge<br>

* `FromBridgeTechnology` - Technology in use by the bridge<br>

* `FromBridgeCreator` - Entity that created the bridge if applicable<br>

* `FromBridgeName` - Name used to refer to the bridge by its BridgeCreator if applicable<br>

* `FromBridgeNumChannels` - Number of channels in the bridge<br>

* `FromBridgeVideoSourceMode` - 
    * `none`

    * `talker`

    * `single`
The video source mode for the bridge.<br>

* `FromBridgeVideoSource` - If there is a video source for the bridge, the unique ID of the channel that is the video source.<br>

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 