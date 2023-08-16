---
title: Asterisk Configuration for ARI
pageid: 29395596
---

Overview
========

ARI has a number of parts to it - the HTTP server in Asterisk servicing requests, the dialplan application handing control of channels over to a connected client, and the websocket sharing state in Asterisk with the external application. This page provides the configuration files in Asterisk that can be altered to suit deployment considerations.




!!! tip 
    This page does not include all of the configuration options available to a system administrator. It does cover some of the basics that you might be interested in when setting up your Asterisk system for ARI.

      
[//]: # (end-tip)



Asterisk Configuration Options for ARI
======================================

HTTP Server
-----------

The HTTP server in Asterisk is configured via `http.conf`. Note that this does not describe all of the options available via `http.conf` - rather, it lists the most useful ones for ARI.

On This Page




| Section | Parameter | Type | Default | Description |
| --- | --- | --- | --- | --- |
| `general` |  |  |  |  |
|  | `enabled` | Boolean | False | Enable the HTTP server. **The HTTP server in Asterisk is disabled by default**. Unless it is enabled, ARI will not function! |
|  | `bindaddr` | IP Address |  | The IP address to bind the HTTP server to. This can either be an explicit local address, or `0.0.0.0` to bind to all available interfaces. |
|  | `bindport` | Port | 8088 | The port to bind the HTTP server to. Client making HTTP requests should specify 8088 as the port to send the request to. |
|  | `prefix` | String |  | A prefix to require for all requests. If specified, requests must begin with the specified prefix. |
|  | `tlsenable` | Boolean | False | Enable HTTPS |
|  | `tlsbindaddr` | IP Address/Port |  | The IP address and port to bind the HTTPS server to. This should be an IP address and port, e.g., `0.0.0.0:8089` |
|  | `tlscertfile` | Path |  | The full path to the certificate file to use. Asterisk only supports the `.pem` format. |
|  | `tlsprivatekey` | Path |  | The full path to the private key file. Asterisk only supports the `.pem` format. If this is not specified, the certificate specified in `tlscertfile` will be searched for the private key. |

### Example http.conf




---

  
http.conf  

```
truetext[general]
enabled = yes
bindaddr = 0.0.0.0
bindport = 8088

```



!!! note Use TLS!** It is **highly
    recommended that you encrypt your HTTP signalling with TLS, and use secure WebSockets (WSS) for your events. This requires configuring the TLS information in `http.conf`, and establishing secure websocket/secure HTTP connections from your ARI application.

      
[//]: # (end-note)



ARI Configuration
-----------------

ARI users and properties are configured via `ari.conf`. Note that all options may not be listed here; this listing includes the most useful ones for configuring users in ARI. For a full description, see the [ARI configuration](/latest_api/API_Documentation/Module_Configuration/res_ari) documentation.



| Section | Parameter | Type | Default | Description |
| --- | --- | --- | --- | --- |
| `general` |  |  |  |  |
|  | `enabled` | Boolean | Yes | Enable/disable ARI. |
|  | `pretty` | Boolean | No | Format JSON responses and events in a human readable form. This makes the output easier to read, at the cost of some additional bytes. |
|  | `allowed_origins` | String |  | A comma separated list of allowed origins for [Cross-Origin Resource Sharing](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing). |
| [user_name] |  |  |  |  |
|  | `type` | String |  | Must be `user`. Specifies that this configuration section defines a user for ARI. |
|  | `read_only` | Boolean | No | Whether or not the user can issue requests that alter the Asterisk system. If set to Yes, then only `GET` and `OPTIONS` HTTP requests will be serviced. |
|  | `password_format` | String | plain | Can be either `plain` or `crypt`. When the password is plain, Asterisk will expect the user's password to be in plain text in the `password` field. When set to `crypt`, Asterisk will use `crypt(3)` to decrypt the password. A crypted password can be generated using `mkpasswd -m sha-512`. |
|  | `password` | String |  | The password for the user. |

### Example ari.conf




---

  
ari.conf  

```
truetext[general]
enabled = yes
pretty = yes
allowed_origins = localhost:8088,http://ari.asterisk.org

[asterisk]
type = user
read_only = no
password = asterisk

; password_format may be set to plain (the default) or crypt. When set to crypt,
; crypt(3) is used to validate the password. A crypted password can be generated
; using mkpasswd -m sha-512.
;
[asterisk-supersecret]
type = user
read_only = no
password = $6$nqvAB8Bvs1dJ4V$8zCUygFXuXXp8EU3t2M8i.N8iCsY4WRchxe2AYgGOzHAQrmjIPif3DYrvdj5U2CilLLMChtmFyvFa3XHSxBlB/
password_format = crypt

```



Configuring the Dialplan for ARI
================================

By default, ARI cannot just manipulate any arbitrary channel in Asterisk. That channel may be in a long running dialplan application; it may be controlled by an AGI; it may be hung up! Many operations that ARI exposes would be fundamentally unsafe if Asterisk did not hand control of the channel over to ARI in a safe fashion.

To hand a channel over to ARI, Asterisk uses a dialplan application called [Stasis](/latest_api/API_Documentation/Dialplan_Applications/Stasis). Stasis acts as any other dialplan application in Asterisk, except that it does not do anything to the channel other than safely pass control over to an ARI application. The Stasis dialplan application takes in two parameters:

1. The name of the ARI application to hand the channel over to. Multiple ARI applications can exist with a single instance of Asterisk, and each ARI application will only be able to manipulate the channels that it controls.
2. Optionally, arguments to pass to the ARI application when the channel is handed over.

### Example: Two ARI Applications

This snippet of dialplan, taken from `extensions.conf`, illustrates two ARI applications. The first hands a channel over to an ARI application "Intro-IVR" without any additional parameters; the second hands a channel over to an ARI application "Super-Conference" with a parameter that specifies a conference room to enter.




---

  
extensions.conf  

```
true[default]

exten => ivr,1,NoOp()
 same => n,Stasis(Intro-IVR)
 same => n,Hangup()

exten => conference,1,NoOp()
 same => n,Stasis(Super-Conference,100)
 same => n,Hangup()

```



When a channel enters into a Stasis application, Asterisk will check to see if a WebSocket connection has been established for that application. If so, the channel is handed over to ARI for control, a subscription for the channel is made for the WebSocket, and a [StasisStart](/latest_api/API_Documentation/Asterisk_REST_Interface/_Asterisk_REST_Data_Models/#StasisStart) event is sent to the WebSocket notifying it that a channel has entered into its application.




!!! note A WebSocket connection is necessary!
    If you have not connected a WebSocket to Asterisk for a particular application, when a channel enters into Stasis for that application, Asterisk will immediately eject the channel from the application and return back to the dialplan. This is to prevent channels from entering into an application before something is ready to handle them.

    Note that if a connection is broken, Asterisk will know that a connection previously existed and will allow channels to enter (although you may got warned that events are about to get missed...)

      
[//]: # (end-note)



