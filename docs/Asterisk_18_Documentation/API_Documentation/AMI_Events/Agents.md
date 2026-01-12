---
search:
  boost: 0.5
title: Agents
---

# Agents

### Synopsis

Response event in a series to the Agents AMI action containing information about a defined agent.

### Description

The channel snapshot is present if the Status value is 'AGENT\_IDLE' or 'AGENT\_ONCALL'.<br>


### Syntax


```


Event: Agents
Agent: <value>
Name: <value>
Status: <value>
TalkingToChan: <value>
CallStarted: <value>
LoggedInTime: <value>
Channel: <value>
ChannelState: <value>
ChannelStateDesc: <value>
CallerIDNum: <value>
CallerIDName: <value>
ConnectedLineNum: <value>
ConnectedLineName: <value>
Language: <value>
AccountCode: <value>
Context: <value>
Exten: <value>
Priority: <value>
Uniqueid: <value>
Linkedid: <value>
ActionID: <value>

```
##### Arguments


* `Agent` - Agent ID of the agent.<br>

* `Name` - User friendly name of the agent.<br>

* `Status` - Current status of the agent.<br>
The valid values are:<br>

    * `AGENT_LOGGEDOFF`

    * `AGENT_IDLE`

    * `AGENT_ONCALL`

* `TalkingToChan` - BRIDGEPEER value on agent channel.<br>
Present if Status value is 'AGENT\_ONCALL'.<br>

* `CallStarted` - Epoche time when the agent started talking with the caller.<br>
Present if Status value is 'AGENT\_ONCALL'.<br>

* `LoggedInTime` - Epoche time when the agent logged in.<br>
Present if Status value is 'AGENT\_IDLE' or 'AGENT\_ONCALL'.<br>

* `Channel`

* `ChannelState` - A numeric code for the channel's current state, related to ChannelStateDesc<br>

* `ChannelStateDesc`

    * `Down`

    * `Rsrvd`

    * `OffHook`

    * `Dialing`

    * `Ring`

    * `Ringing`

    * `Up`

    * `Busy`

    * `Dialing Offhook`

    * `Pre-ring`

    * `Unknown`

* `CallerIDNum`

* `CallerIDName`

* `ConnectedLineNum`

* `ConnectedLineName`

* `Language`

* `AccountCode`

* `Context`

* `Exten`

* `Priority`

* `Uniqueid`

* `Linkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `ActionID` - ActionID for this transaction. Will be returned.<br>

### Class

AGENT
### See Also

* [AMI Actions Agents](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/Agents)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 