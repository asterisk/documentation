---
search:
  boost: 0.5
title: AgentLogin
---

# AgentLogin

### Synopsis

Raised when an Agent has logged in.

### Syntax


```


Event: AgentLogin
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
Agent: <value>

```
##### Arguments


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

* `Agent` - Agent ID of the agent.<br>

### Class

AGENT
### See Also

* [Dialplan Applications AgentLogin](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AgentLogin)
* [AMI Events AgentLogoff](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/AgentLogoff)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 