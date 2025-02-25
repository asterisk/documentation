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
| auth_policy| | | | Whether to automatically accept or deny users' subscription requests| |
| [autoprune](#autoprune)| | | | Auto-remove users from buddy list.| |
| autoregister| | | | Auto-register users from buddy list| |
| collection_nodes| | | | Enable support for XEP-0248 for use with distributed device state| |
| debug| | | | Enable/disable XMPP message debugging| |
| pubsub_autocreate| | | | Whether or not the PubSub server supports/is using auto-create for nodes| |


#### Configuration Option Descriptions

##### autoprune

Auto-remove users from buddy list. Depending on the setup (e.g., using your personal Gtalk account for a test) this could cause loss of the contact list.<br>


### [client]: Configuration options for an XMPP client

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| auth_policy| | | | Whether to automatically accept or deny users' subscription requests| |
| [autoprune](#autoprune)| | | | Auto-remove users from buddy list.| |
| autoregister| | | | Auto-register users bfrom buddy list| |
| [buddy](#buddy)| | | | Manual addition of buddy to list| |
| context| | | | Dialplan context to send incoming messages to| |
| debug| | | | Enable debugging| |
| distribute_events| | | | Whether or not to distribute events using this connection| |
| forceoldssl| | | | Force the use of old-style SSL for the connection| |
| keepalive| | | | If enabled, periodically send an XMPP message from this client with an empty message| |
| oauth_clientid| | | | Google OAuth 2.0 application's client id| |
| oauth_secret| | | | Google OAuth 2.0 application's secret| |
| port| | | | XMPP server port| |
| priority| | | | XMPP resource priority| |
| pubsub_node| | | | Node for publishing events via PubSub| |
| refresh_token| | | | Google OAuth 2.0 refresh token| |
| secret| | | | XMPP password| |
| sendtodialplan| | | | Send incoming messages into the dialplan| |
| serverhost| | | | Route to server, e.g. talk.google.com| |
| [status](#status)| | | | Default XMPP status for the client| |
| statusmessage| | | | Custom status message| |
| [timeout](#timeout)| | | | Timeout in seconds to hold incoming messages| |
| type| | | | Connection is either a client or a component| |
| username| | | | XMPP username with optional resource| |
| usesasl| | | | Whether to use SASL for the connection or not| |
| usetls| | | | Whether to use TLS for the connection or not| |


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

This documentation was generated from Asterisk branch 16 using version GIT 