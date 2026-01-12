---
search:
  boost: 0.5
title: res_xmpp
---

# res_xmpp: XMPP Messaging

This configuration documentation is for functionality provided by res_xmpp.

## Configuration File: xmpp.conf

### [global]: Global configuration settings

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| auth_policy| Custom| accept| false| Whether to automatically accept or deny users' subscription requests| |
| [autoprune](#autoprune)| Custom| no| false| Auto-remove users from buddy list.| |
| autoregister| Custom| yes| false| Auto-register users from buddy list| |
| collection_nodes| Custom| no| false| Enable support for XEP-0248 for use with distributed device state| |
| debug| Custom| no| false| Enable/disable XMPP message debugging| |
| pubsub_autocreate| Custom| no| false| Whether or not the PubSub server supports/is using auto-create for nodes| |


#### Configuration Option Descriptions

##### autoprune

Auto-remove users from buddy list. Depending on the setup (e.g., using your personal Gtalk account for a test) this could cause loss of the contact list.<br>


### [client]: Configuration options for an XMPP client

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| auth_policy| Custom| | false| Whether to automatically accept or deny users' subscription requests| |
| [autoprune](#autoprune)| Custom| | false| Auto-remove users from buddy list.| |
| autoregister| Custom| | false| Auto-register users bfrom buddy list| |
| [buddy](#buddy)| Custom| | false| Manual addition of buddy to list| |
| context| String| default| false| Dialplan context to send incoming messages to| |
| debug| Custom| no| false| Enable debugging| |
| distribute_events| Custom| no| false| Whether or not to distribute events using this connection| |
| forceoldssl| Custom| no| false| Force the use of old-style SSL for the connection| |
| keepalive| Custom| yes| false| If enabled, periodically send an XMPP message from this client with an empty message| |
| oauth_clientid| String| | false| Google OAuth 2.0 application's client id| |
| oauth_secret| String| | false| Google OAuth 2.0 application's secret| |
| port| Unsigned Integer| 5222| false| XMPP server port| |
| priority| Unsigned Integer| 1| false| XMPP resource priority| |
| pubsub_node| String| | false| Node for publishing events via PubSub| |
| refresh_token| String| | false| Google OAuth 2.0 refresh token| |
| secret| String| | false| XMPP password| |
| sendtodialplan| Custom| no| false| Send incoming messages into the dialplan| |
| serverhost| String| | false| Route to server, e.g. talk.google.com| |
| [status](#status)| Custom| available| false| Default XMPP status for the client| |
| statusmessage| String| Online and Available| false| Custom status message| |
| [timeout](#timeout)| Unsigned Integer| 5| false| Timeout in seconds to hold incoming messages| |
| type| Custom| client| false| Connection is either a client or a component| |
| username| String| | false| XMPP username with optional resource| |
| usesasl| Custom| yes| false| Whether to use SASL for the connection or not| |
| usetls| Custom| yes| false| Whether to use TLS for the connection or not| |


#### Configuration Option Descriptions

##### autoprune

Auto-remove users from buddy list. Depending on the setup (e.g., using your personal Gtalk account for a test) this could cause loss of the contact list.<br>


##### buddy

Manual addition of buddy to the buddy list. For distributed events, these buddies are automatically added in the whitelist as 'owners' of the node(s).<br>


##### status

Can be one of the following XMPP statuses:<br>


* `chat`

* `available`

* `away`

* `xaway`

* `dnd`

##### timeout

Timeout (in seconds) on the message stack. Messages stored longer than this value will be deleted by Asterisk. This option applies to incoming messages only which are intended to be processed by the 'JABBER\_RECEIVE' dialplan function.<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 