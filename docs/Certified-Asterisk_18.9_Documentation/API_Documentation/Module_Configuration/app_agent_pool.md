---
search:
  boost: 0.5
title: app_agent_pool
---

# app_agent_pool: Agent pool applications

This configuration documentation is for functionality provided by app_agent_pool.

## Overview


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///


## Configuration File: agents.conf

### [global]: Unused, but reserved.



### [agent-id]: Configure an agent for the pool.


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [acceptdtmf](#acceptdtmf)| String| #| false| DTMF key sequence the agent uses to acknowledge a call.| |
| [ackcall](#ackcall)| Boolean| no| false| Enable to require the agent to acknowledge a call.| |
| [autologoff](#autologoff)| Unsigned Integer| 0| false| Time the agent has to acknowledge a call before being logged off.| |
| [custom_beep](#custom_beep)| String| beep| false| Sound file played to alert the agent when a call is present.| |
| [fullname](#fullname)| String| | false| A friendly name for the agent used in log messages.| |
| [musiconhold](#musiconhold)| String| default| false| Music on hold class the agent listens to between calls.| |
| [recordagentcalls](#recordagentcalls)| Boolean| no| false| Enable to automatically record calls the agent takes.| |
| [wrapuptime](#wrapuptime)| Unsigned Integer| 0| false| Minimum time the agent has between calls.| |


#### Configuration Option Descriptions

##### acceptdtmf


/// note
The option is overridden by **AGENTACCEPTDTMF** on agent login.
///


/// note
The option is ignored unless the ackcall option is enabled.
///


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///


##### ackcall

Enable to require the agent to give a DTMF acknowledgement when the agent receives a call.<br>


/// note
The option is overridden by **AGENTACKCALL** on agent login.
///


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///


##### autologoff

Set how many seconds a call for the agent has to wait for the agent to acknowledge the call before the agent is automatically logged off. If set to zero then the call will wait forever for the agent to acknowledge.<br>


/// note
The option is overridden by **AGENTAUTOLOGOFF** on agent login.
///


/// note
The option is ignored unless the ackcall option is enabled.
///


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///


##### custom_beep


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///


##### fullname


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///


##### musiconhold


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///


##### recordagentcalls

Enable recording calls the agent takes automatically by invoking the automixmon DTMF feature when the agent connects to a caller. See *features.conf.sample* for information about the automixmon feature.<br>


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///


##### wrapuptime

Set the minimum amount of time in milliseconds after disconnecting a call before the agent can receive a new call.<br>


/// note
The option is overridden by **AGENTWRAPUPTIME** on agent login.
///


/// note
Option changes take effect on agent login or after an agent disconnects from a call.
///



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 