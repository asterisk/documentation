---
search:
  boost: 0.5
title: AgentRequest
---

# AgentRequest()

### Synopsis

Request an agent to connect with the channel.

### Description

Request an agent to connect with the channel. Failure to find, alert the agent, or acknowledge the call will continue in the dialplan with **AGENT\_STATUS** set.<br>

AGENT_STATUS enumeration values:<br>


* `INVALID` - The specified agent is invalid.<br>

* `NOT_LOGGED_IN` - The agent is not available.<br>

* `BUSY` - The agent is on another call.<br>

* `NOT_CONNECTED` - The agent did not connect with the call. The agent most likely did not acknowledge the call.<br>

* `ERROR` - Alerting the agent failed.<br>

### Syntax


```

AgentRequest(AgentId)
```
##### Arguments


* `AgentId`

### See Also

* [Dialplan Applications AgentLogin](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/AgentLogin)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 