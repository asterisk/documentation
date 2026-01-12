---
search:
  boost: 0.5
title: PJSIPNotify
---

# PJSIPNotify()

### Synopsis

Send a NOTIFY to either an arbitrary URI, or inside a SIP dialog.

### Description

Sends a NOTIFY to a specified URI, or if none provided, within the current SIP dialog for the current channel. The content can either be set to either an entry configured in pjsip\_notify.conf or specified as a list of key value pairs.<br>


/// warning
To send a NOTIFY to a specified URI, a default\_outbound\_endpoint must be configured. This endpoint determines the message contact.
///

<br>

``` title="Example: Send a NOTIFY with Event and X-Data headers in current dialog"

same = n,PJSIPNotify(,&Event=Test&X-Data=Fun)

			
```
``` title="Example: Send a preconfigured NOTIFY force-answer defined in pjsip_notify.conf in current dialog"

same = n,PJSIPNotify(,force-answer)

			
```
``` title="Example: Send a NOTIFY to <sip:bob@127.0.0.1:5260> with Test Event and X-Data headers"

same = n,PJSIPNotify(<sip:bob@127.0.0.1:5260>,&Event=Test&X-Data=Fun)

			
```
``` title="Example: Send a NOTIFY to <sip:bob@127.0.0.1:5260> with Custom Event and message body"

same = n,PJSIPNotify(<sip:bob@127.0.0.1:5260>,&Event=Custom&Content-type=application/voicemail&Content=check-messages&Content=)

		
```

### Syntax


```

PJSIPNotify([to,]content)
```
##### Arguments


* `to` - Abritrary URI to which to send the NOTIFY. If none is specified, send inside the SIP dialog for the current channel.<br>

* `content` - Either an option pre-configured in pjsip\_notify.conf or a list of headers and body content to send in the NOTIFY.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 