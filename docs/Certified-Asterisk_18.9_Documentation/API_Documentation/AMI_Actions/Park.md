---
search:
  boost: 0.5
title: Park
---

# Park

### Synopsis

Park a channel.

### Description

Park an arbitrary channel with optional arguments for specifying the parking lot used, how long the channel should remain parked, and what dial string to use as the parker if the call times out.<br>


### Syntax


```


Action: Park
ActionID: <value>
Channel: <value>
[TimeoutChannel: <value>]
[AnnounceChannel: <value>]
[Timeout: <value>]
[Parkinglot: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel name to park.<br>

* `TimeoutChannel` - Channel name to use when constructing the dial string that will be dialed if the parked channel times out. If 'TimeoutChannel' is in a two party bridge with 'Channel', then 'TimeoutChannel' will receive an announcement and be treated as having parked 'Channel' in the same manner as the Park Call DTMF feature.<br>

* `AnnounceChannel` - If specified, then this channel will receive an announcement when 'Channel' is parked if 'AnnounceChannel' is in a state where it can receive announcements (AnnounceChannel must be bridged). 'AnnounceChannel' has no bearing on the actual state of the parked call.<br>

* `Timeout` - Overrides the timeout of the parking lot for this park action. Specified in milliseconds, but will be converted to seconds. Use a value of 0 to disable the timeout.<br>

* `Parkinglot` - The parking lot to use when parking the channel<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 