---
search:
  boost: 0.5
title: AGENT
---

# AGENT()

### Synopsis

Gets information about an Agent

### Description


### Syntax


```

AGENT(AgentId:item)
```
##### Arguments


* `AgentId`

* `item` - The valid items to retrieve are:<br>

    * `status` - (default) The status of the agent (LOGGEDIN | LOGGEDOUT)<br>

    * `password` - Deprecated. The dialplan handles any agent authentication.<br>

    * `name` - The name of the agent<br>

    * `mohclass` - MusicOnHold class<br>

    * `channel` - The name of the active channel for the Agent (AgentLogin)<br>

    * `fullchannel` - The untruncated name of the active channel for the Agent (AgentLogin)<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 