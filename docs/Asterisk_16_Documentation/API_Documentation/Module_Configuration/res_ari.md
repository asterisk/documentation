---
search:
  boost: 0.5
title: res_ari
---

# res_ari: HTTP binding for the Stasis API

This configuration documentation is for functionality provided by res_ari.

## Configuration File: ari.conf

### [general]: General configuration settings

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| allowed_origins| String| | false| Comma separated list of allowed origins, for Cross-Origin Resource Sharing. May be set to * to allow all origins.| |
| auth_realm| String| Asterisk REST Interface| false| Realm to use for authentication. Defaults to Asterisk REST Interface.| |
| channelvars| Custom| | false| Comma separated list of channel variables to display in channel json.| |
| [enabled](#enabled)| Boolean| yes| false| Enable/disable the ARI module| |
| pretty| Custom| no| false| Responses from ARI are formatted to be human readable| |
| [websocket_write_timeout](#websocket_write_timeout)| Integer| 100| false| The timeout (in milliseconds) to set on WebSocket connections.| |


#### Configuration Option Descriptions

##### enabled

This option enables or disables the ARI module.<br>


/// note
ARI uses Asterisk's HTTP server, which must also be enabled in *http.conf*.
///


##### websocket_write_timeout

If a websocket connection accepts input slowly, the timeout for writes to it can be increased to keep it from being disconnected. Value is in milliseconds.<br>


### [user]: Per-user configuration settings

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| password| String| | false| Crypted or plaintext password (see password_format)| |
| password_format| Custom| plain| false| password_format may be set to plain (the default) or crypt. When set to crypt, crypt(3) is used to validate the password. A crypted password can be generated using mkpasswd -m sha-512. When set to plain, the password is in plaintext| |
| read_only| Boolean| no| false| When set to yes, user is only authorized for read-only requests| |
| [type](#type)| None| | false| Define this configuration section as a user.| |


#### Configuration Option Descriptions

##### type


* `user` - Configure this section as a _user_<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 