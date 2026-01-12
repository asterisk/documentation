---
search:
  boost: 0.5
title: AgentLogin
---

# AgentLogin()

### Synopsis

Login an agent.

### Description

Login an agent to the system. Any agent authentication is assumed to already be done by dialplan. While logged in, the agent can receive calls and will hear the sound file specified by the config option custom\_beep when a new call comes in for the agent. Login failures will continue in the dialplan with **AGENT\_STATUS** set.<br>

Before logging in, you can setup on the real agent channel the CHANNEL(dtmf\_features) an agent will have when talking to a caller and you can setup on the channel running this application the CONNECTEDLINE() information the agent will see while waiting for a caller.<br>

AGENT_STATUS enumeration values:<br>


* `INVALID` - The specified agent is invalid.<br>

* `ALREADY_LOGGED_IN` - The agent is already logged in.<br>

/// note
The Agent:_AgentId_ device state is available to monitor the status of the agent.
///


### Syntax


```

AgentLogin(AgentId,[options])
```
##### Arguments


* `AgentId`

* `options`

    * `s` - silent login - do not announce the login ok segment after agent logged on.<br>


### See Also

* [Dialplan Applications Authenticate](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Authenticate)
* [Dialplan Applications Queue](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Queue)
* [Dialplan Applications AddQueueMember](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AddQueueMember)
* [Dialplan Applications RemoveQueueMember](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/RemoveQueueMember)
* [Dialplan Applications PauseQueueMember](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/PauseQueueMember)
* [Dialplan Applications UnpauseQueueMember](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/UnpauseQueueMember)
* [Dialplan Functions AGENT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/AGENT)
* [Dialplan Functions CHANNEL](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CHANNEL)
* [Dialplan Functions CONNECTEDLINE](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CONNECTEDLINE)
* {{agents.conf}}
* {{queues.conf}}


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 