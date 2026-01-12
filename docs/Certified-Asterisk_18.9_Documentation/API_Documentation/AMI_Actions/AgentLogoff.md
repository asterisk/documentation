---
search:
  boost: 0.5
title: AgentLogoff
---

# AgentLogoff

### Synopsis

Sets an agent as no longer logged in.

### Description

Sets an agent as no longer logged in.<br>


### Syntax


```


Action: AgentLogoff
ActionID: <value>
Agent: <value>
Soft: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Agent` - Agent ID of the agent to log off.<br>

* `Soft` - Set to 'true' to not hangup existing calls.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 