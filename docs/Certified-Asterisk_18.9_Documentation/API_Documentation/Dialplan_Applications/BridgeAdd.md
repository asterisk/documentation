---
search:
  boost: 0.5
title: BridgeAdd
---

# BridgeAdd()

### Synopsis

Join a bridge that contains the specified channel.

### Description

This application places the incoming channel into the bridge containing the specified channel. The specified channel only needs to be the prefix of a full channel name IE. 'PJSIP/cisco0001'.<br>

This application sets the following channel variable upon completion:<br>


* `BRIDGERESULT` - The result of the bridge attempt as a text string.<br>

    * `SUCCESS`

    * `FAILURE`

    * `LOOP`

    * `NONEXISTENT`

### Syntax


```

BridgeAdd(channel)
```
##### Arguments


* `channel` - The current channel joins the bridge containing the channel identified by the channel name, channel name prefix, or channel uniqueid.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 